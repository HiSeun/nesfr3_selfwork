#include "nesfr3_mecanum_driver/mec_driver.h"

#include <csignal>
#include <math.h>

#define ODOM_RATE 500
#define WHEEL_RAD 0.06
#define WHEEL_DIST_W 0.15
#define WHEEL_DIST_H 0.20

volatile sig_atomic_t is_done = false;

void sigHandler(int sig){
    is_done = true;
}

namespace nesfr3_mecanum_driver{
    MecanumDriver::MecanumDriver(uint32_t nesfr3_index){
        std::string ns = "/nesfr3/" + std::to_string(nesfr3_index); 
        cmd_sub_ = nh_.subscribe<geometry_msgs::Twist>(ns + "/cmd_vel", 1,
                &MecanumDriver::cmdCallback, this);
        odom_pub_ = nh_.advertise<nav_msgs::Odometry>(ns + "/wheel_odom", 1);
        wheel_pub_[0] = nh_.advertise<geometry_msgs::Twist>(ns + "/wheel0_vel", 1);
        wheel_pub_[1] = nh_.advertise<geometry_msgs::Twist>(ns + "/wheel1_vel", 1);
        wheel_pub_[2] = nh_.advertise<geometry_msgs::Twist>(ns + "/wheel2_vel", 1);
        wheel_pub_[3] = nh_.advertise<geometry_msgs::Twist>(ns + "/wheel3_vel", 1);
        motor_sp_q_[0].push(0);
        motor_sp_q_[0].push(0);
        motor_sp_q_[0].push(0);
        motor_sp_q_[0].push(0);
        motor_sp_q_[1].push(0);
        motor_sp_q_[1].push(0);
        motor_sp_q_[1].push(0);
        motor_sp_q_[1].push(0);
        motor_sp_q_[2].push(0);
        motor_sp_q_[2].push(0);
        motor_sp_q_[2].push(0);
        motor_sp_q_[2].push(0);
        motor_sp_q_[3].push(0);
        motor_sp_q_[3].push(0);
        motor_sp_q_[3].push(0);
        motor_sp_q_[3].push(0);
    }

    int MecanumDriver::initCanSock(){
        struct sockaddr_can addr;
        struct ifreq ifr;

        if((can_fd_ = socket(PF_CAN, SOCK_RAW, CAN_RAW)) < 0){
            perror("socket");
            return -1;
        }

        strcpy(ifr.ifr_name, "can0");
        ioctl(can_fd_, SIOCGIFINDEX, &ifr);

        memset(&addr, 0, sizeof(addr));
        addr.can_family = AF_CAN;
        addr.can_ifindex = ifr.ifr_ifindex;

        struct can_filter rdfilter[4];
        for(int i = 0; i < 4;i++){
            rdfilter[i].can_id = 0x141 + i;
            rdfilter[i].can_mask = CAN_SFF_MASK;
        }

        setsockopt(can_fd_, SOL_CAN_RAW, CAN_RAW_FILTER, &rdfilter, sizeof(rdfilter));
        

        if(bind(can_fd_, (struct sockaddr *) &addr, sizeof(addr)) < 0){
            perror("bind");
            return -1;
        }

        return 0;
    }

    void MecanumDriver::cmdCallback(const geometry_msgs::Twist::ConstPtr& msg){
        float linear_x = msg->linear.x;
        float linear_y = msg->linear.y;
        float angular_z = msg->angular.z;

        float vel[4];
        // convert from planar velocity to mecanum wheel velocity
        vel[1] = 1 / WHEEL_RAD * (linear_x - linear_y -
           (WHEEL_DIST_W + WHEEL_DIST_H) * angular_z);
        vel[0] = 1 / WHEEL_RAD * (linear_x + linear_y + 
           (WHEEL_DIST_W + WHEEL_DIST_H) * angular_z);
        vel[3] = 1 / WHEEL_RAD * (linear_x + linear_y -
           (WHEEL_DIST_W + WHEEL_DIST_H) * angular_z);
        vel[2] = 1 / WHEEL_RAD * (linear_x - linear_y +
                (WHEEL_DIST_W + WHEEL_DIST_H) * angular_z);

        vel[1] = -vel[1];
        vel[3] = -vel[3];

        // convert to CAN bus unit which has MSB=0.01dps 
        cmd_vel_[0] = static_cast<int32_t>(vel[0] * 180 / M_PI / 0.01); 
        cmd_vel_[1] = static_cast<int32_t>(vel[1] * 180 / M_PI / 0.01); 
        cmd_vel_[2] = static_cast<int32_t>(vel[2] * 180 / M_PI / 0.01); 
        cmd_vel_[3] = static_cast<int32_t>(vel[3] * 180 / M_PI / 0.01); 
    }

    void MecanumDriver::readLoop(){
        fd_set fds;
        struct timeval timeout;
        struct can_frame reply;
        int nbytes, rv;
        while(!is_done){ 
            FD_ZERO(&fds);
            FD_SET(can_fd_, &fds);
            timeout.tv_sec = 1;
            timeout.tv_usec = 0;

            // We need to use select/poll in order to do non-blocking read.
            // Otherwise, the last read may block the thread loop, making it hard to kill.
            if((rv = select(can_fd_ + 1, &fds, NULL, NULL, &timeout)) < 0){
                ROS_ERROR("SELECT");
                perror("select");
                is_done = true;
            }else if(rv == 0){
                ROS_ERROR("TIMEOUT");
                continue;
            }
            
            if((nbytes = read(can_fd_, &reply, sizeof(struct can_frame))) < 0){
                ROS_ERROR("READ");
                perror("read");
            }
            
            int motor_id = reply.can_id - 0x141;
            if(reply.data[0] == 0x92){
                memcpy((void *)&motor_angle_[motor_id] + 1, &reply.data[1], 7);
            }
            if(reply.data[0] == 0xA2){
                short tmp = motor_torque_[motor_id];
                memcpy((void *)&motor_torque_[motor_id], &reply.data[2], 2);
                motor_torque_[motor_id] = motor_torque_[motor_id] * 0.1 + 0.9 * tmp;
                memcpy((void *)&motor_speed_[motor_id], &reply.data[4], 2);
                std::lock_guard<std::mutex> lock(rw_mutex_);
                motor_sp_q_[motor_id].push(motor_speed_[motor_id]);
                if(motor_sp_q_[motor_id].size() > 4){
                    motor_sp_q_[motor_id].pop();
                }
            }
        }
        ROS_WARN("DONE READING");
    }
    
    void MecanumDriver::initOdom(){
        // send read motor angle cmd
        struct can_frame read_cmd;
        struct can_frame reply;
        memset(&read_cmd, 0, sizeof(read_cmd));
        read_cmd.can_dlc = 8;
        read_cmd.data[0] = 0x92;
        for(int i = 0; i < 4;i++){
            read_cmd.can_id = 0x141 + i;
            write(can_fd_, &read_cmd, sizeof(struct can_frame));

read_again:
            int nbytes;
            if((nbytes = read(can_fd_, &reply, sizeof(struct can_frame))) < 0){
                ROS_ERROR("READ");
                perror("read");
            }
            int motor_id = reply.can_id - 0x141;
            if(reply.data[0] == 0x92 && motor_id == i){
                memcpy((void *)&init_angle_[motor_id] + 1, &reply.data[1], 7);
            }else{
                goto read_again;
            }
        }
    }

    void MecanumDriver::publishOdom(){
        nav_msgs::Odometry msg;

        // send read motor angle cmd
        struct can_frame read_cmd;
        memset(&read_cmd, 0, sizeof(read_cmd));
        read_cmd.can_dlc = 8;
        read_cmd.data[0] = 0x92;
        for(int i = 0; i < 4;i++){
            read_cmd.can_id = 0x141 + i;
            write(can_fd_, &read_cmd, sizeof(struct can_frame));
        }


        // calculate dacc = dvel/dt
        // NOTE: Ignored the division by dt in here since measuring it
        //       is complicted
        float motor_acc[4];
        float old_sp[4] = {0};
        {
            std::lock_guard<std::mutex> lock(rw_mutex_);

            for(int i = 0; i < 4;i++){
                size_t size = motor_sp_q_[i].size();
                for(size_t j = 0;j < size;j++){
                    short tmp = motor_sp_q_[i].front();
                    old_sp[i] += (float)tmp / size;
                    motor_sp_q_[i].pop();
                    motor_sp_q_[i].push(tmp);
                    
                }
                motor_acc[i] = (float)motor_speed_[i] - old_sp[i];
                // 1st order low pass filter with alpha = 0.1
                motor_acc_[i] = 0.9 * motor_acc_[i] + 0.1 * motor_acc[i];
            }
        }

        // calculate traction of each wheel
        // NOTE: I just used random functions which I believed to be fitting well
        //       when normalizing/calculating coefficients
        float traction_coef[4];
        for(int i = 0; i < 4;i++){
            if(abs(motor_torque_[i]) > 100){
                float normalized_torque = tanh((float) abs(motor_torque_[i]) / 500);
                float ratio = abs(((float) motor_acc_[i] / 200) / normalized_torque);
                traction_coef[i] = ratio / (1 + ratio);
            }else{
                traction_coef[i] = 0;
            }
        }

        // send set speed cmd which returns its current speed and torque
        struct can_frame vel_cmd;
        memset(&vel_cmd, 0, sizeof(vel_cmd));
        vel_cmd.can_dlc = 8;
        for(int i = 0; i < 4;i++){
            vel_cmd.can_id = 0x141 + i;
            int32_t can_speed = cmd_vel_[i];
            
            // if wheel is slipping, slow it down
            // NOT WORKING AS INTENDED SO I WILL JUST TURN IT OFF
            traction_stat_[i] = OFF;
            
            if(traction_stat_[i] == OFF){
                if(traction_coef[i] > 0.2){
                    traction_stat_[i] = abs(motor_speed_[i]) < abs(old_sp[i]) ? DECEL : ACCEL;
                    throttle_[i] = abs(motor_speed_[i]) < abs(old_sp[i]) ? old_sp[i] * 100 : 0;
                }
            }else{
                if(traction_coef[i] < 0.05){
                    traction_stat_[i] = OFF;
                }else{
                    can_speed = throttle_[i];
                }
            }
            vel_cmd.data[0] = 0xA2;

            // when it is off the surface, setting speed to 0 makes sound,
            // we can avoid it by sending STOP command instead but it does not
            // return motor's current speed, torque status so I commented the below
            // part
            //
            //if(can_speed == 0 && abs(motor_speed_[i]) < 1) {
            //    vel_cmd.data[0] = 0x81;
            //}else{
                memcpy(&vel_cmd.data[4], &can_speed, 4);
            //}
            write(can_fd_, &vel_cmd, sizeof(struct can_frame));

            // publish some data for analysis
            // NOTE: Use plotjuggler for good visualizing software
            geometry_msgs::Twist wheel_msg;
            wheel_msg.linear.x = abs(throttle_[i]);
            wheel_msg.linear.y = abs(motor_acc_[i]);
            wheel_msg.linear.z = traction_coef[i];
            wheel_msg.angular.z = traction_stat_[i];
            wheel_msg.angular.x = abs(motor_speed_[i]);
            wheel_msg.angular.y = abs(can_speed / 100);

            wheel_pub_[i].publish(wheel_msg);
        }

        msg.header.stamp = ros::Time::now();
        msg.header.frame_id = "nesfr3/1/wheel_odom";
        msg.child_frame_id = "nesfr3/1/base_link";
        float total_displ[4];
        for(int i = 0;i < 4;i++){
            total_displ[i] = (motor_angle_[i] - init_angle_[i]) / 256 * 0.01 * M_PI / 180;
        }

        msg.pose.pose.position.x = (total_displ[0] - total_displ[1] 
                                  + total_displ[2] - total_displ[3]) * WHEEL_RAD / 4;
        msg.pose.pose.position.y = -(total_displ[0] + total_displ[1]
                                   - total_displ[2] - total_displ[3]) * WHEEL_RAD / 4;
        double yaw =  -(total_displ[0] + total_displ[1] + total_displ[2] + total_displ[3])
            * WHEEL_RAD / 4 / (WHEEL_DIST_H + WHEEL_DIST_W);
        msg.pose.pose.orientation.z = sin(yaw);
        msg.pose.pose.orientation.w = cos(yaw);

        
        /* Uncomment to publish wheel odometry tf
         * NOTE: It will break the cartographer if you are not going to use odometry in
         * slam. Currently, I found it hard to tune with odometry as there is too much error
         * in wheel odometry. Maybe we can try once more when we have proper traction control
         * system */
        //geometry_msgs::TransformStamped odom_trans;
        //odom_trans.header.stamp = msg.header.stamp;
        //odom_trans.header.frame_id = "nesfr3/1/base_link";
        //odom_trans.child_frame_id = "nesfr3/1/wheel_odom";

        //odom_trans.transform.translation.x = msg.pose.pose.position.x;
        //odom_trans.transform.translation.y = msg.pose.pose.position.y;
        //odom_trans.transform.translation.z = 0.0;
        //odom_trans.transform.rotation = msg.pose.pose.orientation;

        ////send the transform
        //odom_broadcaster_.sendTransform(odom_trans);
        
        float speed_rad[4];
        for(int i = 0;i < 4;i++){
            speed_rad[i] = motor_speed_[i] * M_PI / 180;
        }
        msg.twist.twist.linear.x = (speed_rad[0] - speed_rad[1] 
                                  + speed_rad[2] - speed_rad[3]) * WHEEL_RAD / 4;
        msg.twist.twist.linear.y = -(speed_rad[0] + speed_rad[1]
                                   - speed_rad[2] - speed_rad[3]) * WHEEL_RAD / 4;
        msg.twist.twist.angular.z = -(speed_rad[0] + speed_rad[1]
                                      + speed_rad[2] + speed_rad[3])
                                      * WHEEL_RAD / 4 / (WHEEL_DIST_H + WHEEL_DIST_W);
        odom_pub_.publish(msg);
    }
}

int main(int argc, char** argv)
{    
    signal(SIGTERM, sigHandler);
    signal(SIGHUP, sigHandler);
    signal(SIGINT, sigHandler);
    ros::init(argc, argv, "nesfr3_mechanum_driver");
    nesfr3_mecanum_driver::MecanumDriver driver(1);
    if(driver.initCanSock() < 0){
        ROS_ERROR("CAN SOCK INIT FAILED");
        return -1;
    }
    ROS_INFO("INITIALIZED CAN SOCKET!");

    driver.initOdom();
    boost::thread read_thr(boost::bind(&nesfr3_mecanum_driver::MecanumDriver::readLoop, &driver));
    ros::Rate r(ODOM_RATE);
    while(ros::ok() && !is_done){
        driver.publishOdom();
        ros::spinOnce();
        r.sleep();
    }
    return 0;
}
