// Copyright (C) 2013-2014 Thalmic Labs Inc.
// Distributed under the Myo SDK license agreement. See LICENSE.txt for details.
#define _USE_MATH_DEFINES

#include <cmath>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <string>
#include <vector>

// The only file that needs to be included to use the Myo C++ SDK is myo.hpp.
#include <myo/myo.hpp>

enum Direction {
    CENTER = 0,
    UP = 1,
    DOWN = 2,
    LEFT = 3,
    RIGHT = 4
};

char *Directions[] = {"CENTER", "UP", "DOWN", "LEFT", "RIGHT"};

//Direction sequence[] = {RIGHT};
Direction sequence[] = {CENTER, UP, DOWN, LEFT, RIGHT, CENTER, LEFT, UP, RIGHT, DOWN, CENTER, DOWN, RIGHT, UP, LEFT, CENTER, RIGHT, LEFT, DOWN, UP};

// Classes that inherit from myo::DeviceListener can be used to receive events from Myo devices. DeviceListener
// provides several virtual functions for handling different kinds of events. If you do not override an event, the
// default behavior is to do nothing.
class DataCollector : public myo::DeviceListener {
public:
    DataCollector()
    : onArm(false), t_acc(0), t_ang(0), t_impact(0), t_ori(0), roll(0.0), pitch(0.0), yaw(0.0), impact(false), next_state(0), acc_acc_count(0), ang_acc_count(0) {
        
    }
    
    // These values are set by onArmRecognized() and onArmLost() above.
    bool onArm;
    myo::Arm whichArm;
    
    int64_t t_acc, t_ang, t_impact, t_ori;
    myo::Vector3<float> acc, ang, gravity;
    myo::Vector3<float> acc_acc, ang_acc, avg_acc, avg_ang;
    int acc_acc_count, ang_acc_count;
    myo::Quaternion<float> ori;
    float roll, pitch, yaw;
    bool impact;
    int next_state;
    
    
    std::ofstream myfile;
    
    // onUnpair() is called whenever the Myo is disconnected from Myo Connect by the user.
    void onUnpair(myo::Myo* myo, uint64_t timestamp)
    {
        // We've lost a Myo.
        // Let's clean up some leftover state.
        onArm = false;
        t_acc = 0;
        t_ang = 0;
        t_ori = 0;
        roll = 0.0;
        pitch = 0.0;
        yaw = 0.0;
        t_impact = 0;
        acc_acc = myo::Vector3<float>();
        ang_acc = myo::Vector3<float>();
        acc_acc_count = 0;
        ang_acc_count = 0;
    }
    
    // given recent impact with acc, ang, ori values, decide what direction it is
    Direction decide(myo::Vector3<float> acc, myo::Vector3<float> ang, myo::Quaternion<float> quat, Direction prev) {
//        // acceleration dominated
//        float up = -acc.z();
//        float down = acc.z();
//        float right = -acc.y();
//        float left = acc.y();
//        
//        if (prev == Direction::UP) {
//        }
//        
//        if (up > down && up > right && up > left) {
//            return Direction::UP;
//        } else if (down > up && down > right && down > left) {
//            return Direction::DOWN;
//        } else if (right > up && right > down && right > left) {
//            return Direction::RIGHT;
//        } else if (left > up && left > down && left > right) {
//            return Direction::LEFT;
//        }
//        
//        //        float UP_PITCH_LO = -1.57; // rad
//        //        float UP_PITCH_HI = 0.0; // rad
        
        Direction next = sequence[next_state];
        next_state++;
        if (next_state >= sizeof(sequence) / sizeof(*sequence)) {
            next_state = 0;
        }
        return next;
//
        
        float roll = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                     1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
        float pitch = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
        float yaw = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                    1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));
        if (yaw < 0) return Direction::LEFT;
        if (abs(yaw) > abs(roll)) return Direction::RIGHT;
        if (yaw > 1) return Direction::DOWN;
        return Direction::UP;
        return prev;
    }
    
    void onAccelerometerData(myo::Myo *myo, uint64_t timestamp, const myo::Vector3< float > &accel)
	{
		using std::sqrt;
        
		// cancel out the effect of gravity using a high-pass filter
        
		// alpha is calculated as t / (t + dT)
		// with t, the low-pass filter's time-constant
		// and dT, the event delivery rate (in the case of Myo, this is 20 ms)
        
		float alpha = 0.8;
        
		gravity = myo::Vector3<float>(alpha * gravity.x() + (1 - alpha) * accel.x(),
                                      alpha * gravity.y() + (1 - alpha) * accel.y(),
                                      alpha * gravity.z() + (1 - alpha) * accel.z());
        
		acc = myo::Vector3<float>(accel.x() - gravity.x(),
                                  accel.y() - gravity.y(),
                                  accel.z() - gravity.z());
        
        float diff = timestamp - t_acc;
        
        t_acc = timestamp;
        
		// calculate the magnitude of the acceleration
		float acc_mag = sqrt(acc.x()*acc.x() +
                             acc.y()*acc.y() +
                             acc.z()*acc.z());
        impact = false;
        
        acc_acc = myo::Vector3<float>(diff * acc.x() + acc_acc.x(),
                                      diff * acc.y() + acc_acc.y(),
                                      diff * acc.z() + acc_acc.z());
        acc_acc_count += 1;
        
        if (acc_mag > 0.7 && acc.x() > 0) {
            if (timestamp - t_impact < 200000 /* ns */)
                return;
            t_impact = timestamp;
            impact = true;
            
//            if (abs(acc_acc.y()) > abs(acc_acc.z())) {
//                if (acc_acc.y() < 0.0) {
//                    std::cout << "RIGHT ";
//                } else {
//                    std::cout << "LEFT ";
//                }
//            } else {
//                if (acc_acc.z() < 0.0) {
//                    std::cout << "DOWN ";
//                } else {
//                    std::cout << "UP ";
//                }
//            }
            // normalize
            avg_acc = myo::Vector3<float>(acc_acc.x() / acc_acc.magnitude(),
                                          acc_acc.y() / acc_acc.magnitude(),
                                          acc_acc.z() / acc_acc.magnitude());
            
            avg_ang = myo::Vector3<float>(ang_acc.x() / (ang_acc.magnitude() + 0.00000001),
                                          ang_acc.y() / (ang_acc.magnitude() + 0.00000001),
                                          ang_acc.z() / (ang_acc.magnitude() + 0.00000001));
            std::cout << "v.x: " << avg_acc.x() << " v.y: " << avg_acc.y() << " v.z: " << avg_acc.z() << std::endl;
            std::cout << "rho.x: " << avg_ang.x() << " rho.y: " << avg_ang.y() << " rho.z: " << avg_ang.z() << std::endl;

            
            acc_acc = myo::Vector3<float>();
            acc_acc_count = 0;
            ang_acc = myo::Vector3<float>();
            ang_acc_count = 0;
            
            
            std::cout << Directions[decide(acc, ang, ori, Direction::CENTER)] << " ";
            
            std::cout << "accel: " << acc.x() << ", " << acc.y() << ", " << acc.z() << std::endl;
            std::cout << "pitch:" << pitch << " roll:" << roll << " yaw:" << yaw << std::endl;
            print();
            
        }
	}
    
    // onGyroscopeData() is called whenever the Myo device provides new gyroscope data,
	// representing the angular velocity in units of deg/s
	void onGyroscopeData(myo::Myo *myo, uint64_t timestamp, const myo::Vector3< float > &gyro)
	{
		using std::sqrt;
        
        ang = gyro;
        float diff = timestamp - t_ang;
        t_ang = timestamp;
        
        ang_acc = myo::Vector3<float>(diff * ang.x() + ang_acc.x(),
                                      diff * ang.y() + ang_acc.y(),
                                      diff * ang.z() + ang_acc.z());
        ang_acc_count += 1;
        
		// calculate the magnitude of the acceleration by using the x(), y(), and z() functions
		// from the Vector3 class to access individual components
		//ang_mag = sqrt(gyro.x()*gyro.x() + gyro.y()*gyro.y() + gyro.z()*gyro.z());
	}
    
    // onOrientationData() is called whenever the Myo device provides its current orientation, which is represented
    // as a unit quaternion.
    void onOrientationData(myo::Myo* myo, uint64_t timestamp, const myo::Quaternion<float>& quat)
    {
        using std::atan2;
        using std::asin;
        using std::sqrt;
        
        ori = quat;
        // Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
        roll = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                     1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
        pitch = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
        yaw = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                    1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));
        
        t_ori = timestamp;
    }
    
    // onArmRecognized() is called whenever Myo has recognized a Sync Gesture after someone has put it on their
    // arm. This lets Myo know which arm it's on and which way it's facing.
    void onArmRecognized(myo::Myo* myo, uint64_t timestamp, myo::Arm arm, myo::XDirection xDirection)
    {
        onArm = true;
        whichArm = arm;
    }
    
    // onArmLost() is called whenever Myo has detected that it was moved from a stable position on a person's arm after
    // it recognized the arm. Typically this happens when someone takes Myo off of their arm, but it can also happen
    // when Myo is moved around on the arm.
    void onArmLost(myo::Myo* myo, uint64_t timestamp)
    {
        onArm = false;
    }
    
    // There are other virtual functions in DeviceListener that we could override here, like onAccelerometerData().
    // For this example, the functions overridden above are sufficient.
    
    //    // We define this function to print the current values that were updated by the on...() functions above.
    //    void print()
    //    {
    //        // Clear the current line
    //        std::cout << '\r';
    //
    //        // Print out the orientation. Orientation data is always available, even if no arm is currently recognized.
    //        std::cout << '[' << roll_r << ']'
    //                  << '[' << pitch_r << ']'
    //                  << '[' << yaw_r << ']';
    //
    //        if (onArm) {
    //            // Print out the currently recognized pose and which arm Myo is being worn on.
    //
    //            // Pose::toString() provides the human-readable name of a pose. We can also output a Pose directly to an
    //            // output stream (e.g. std::cout << currentPose;). In this case we want to get the pose name's length so
    //            // that we can fill the rest of the field with spaces below, so we obtain it as a string using toString().
    //            std::string poseString = currentPose.toString();
    //
    //            std::cout << '[' << (whichArm == myo::armLeft ? "L" : "R") << ']'
    //                      << '[' << poseString << std::string(14 - poseString.size(), ' ') << ']';
    //        } else {
    //            // Print out a placeholder for the arm and pose when Myo doesn't currently know which arm it's on.
    //            std::cout << "[?]" << '[' << std::string(14, ' ') << ']';
    //        }
    //
    //        std::cout << std::flush;
    //    }
    // We define this function to print the current values that were updated by the on...() functions above.
    void print()
    {
        
        // Output the current values
        if (impact) {
            myo::Quaternion<float> quat = ori;
            int sequence_size = sizeof(sequence) / sizeof(*sequence);
            
            float roll = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                         1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
            float pitch = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
            float yaw = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                        1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));
        
            myfile
            << t_acc << "," << t_ang << "," << t_ori << ","
            << acc.x() << "," << acc.y() << "," << acc.z() << ","
            << ang.x() << "," << ang.y() << "," << ang.z() << ","
            << yaw << "," << pitch << "," << roll << ","
            //<< ori.w() << "," << ori.x() << "," << ori.y() << "," << ori.z() << ","
            << avg_acc.x() << "," << avg_acc.y() << "," << avg_acc.z() << ","
            << avg_ang.x() << "," << avg_ang.y() << "," << avg_ang.z() << ","
            << sequence[(next_state - 1 + sequence_size) % sequence_size] << "," << sequence[next_state]
            //<< roll << "," << pitch << "," << yaw << ","
            //<< gravity.x() << "," << gravity.y() << "," << gravity.z() << "\n"
            << std::endl << std::flush;
            impact = false;
        }
    }
    
};

int main(int argc, char** argv)
{
    // We catch any exceptions that might occur below -- see the catch statement for more details.
    try {
        
        // First, we create a Hub with our application identifier. Be sure not to use the com.example namespace when
        // publishing your application. The Hub provides access to one or more Myos.
        myo::Hub hub("com.example.hello-myo");
        
        std::cout << "Attempting to find a Myo..." << std::endl;
        
        // Next, we attempt to find a Myo to use. If a Myo is already paired in Myo Connect, this will return that Myo
        // immediately.
        // waitForAnyMyo() takes a timeout value in milliseconds. In this case we will try to find a Myo for 10 seconds, and
        // if that fails, the function will return a null pointer.
        myo::Myo* myo = hub.waitForMyo(10000);
        
        // If waitForAnyMyo() returned a null pointer, we failed to find a Myo, so exit with an error message.
        if (!myo) {
            throw std::runtime_error("Unable to find a Myo!");
        }
        
        // We've found a Myo.
        std::cout << "Connected to a Myo armband!" << std::endl << std::endl;
        
        // Next we construct an instance of our DeviceListener, so that we can register it with the Hub.
        DataCollector collector;
        
        // Hub::addListener() takes the address of any object whose class inherits from DeviceListener, and will cause
        // Hub::run() to send events to all registered device listeners.
        hub.addListener(&collector);
        
        collector.myfile.open("/Users/jczhang/Downloads/sdk/out.csv");
        collector.myfile << "t_acc,t_ang,t_ori,acc.x,acc.y,acc.z,ang.x,ang.y,ang.z,yaw,pitch,roll,avg_acc.x,avg_acc.y,avg_acc.z,avg_ang.x,avg_ang.y,avg_ang.z,prev,class\n";
        
        // Finally we enter our main loop.
        while (1) {
            // In each iteration of our main loop, we run the Myo event loop for a set number of milliseconds.
            // In this case, we wish to update our display 20 times a second, so we run for 1000/20 milliseconds.
            hub.run(20);
            // After processing events, we call the print() member function we defined above to print out the values we've
            // obtained from any events that have occurred.
            //collector.print();
        }
        
        // If a standard exception occurred, we print out its message and exit.
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        std::cerr << "Press enter to continue.";
        std::cin.ignore();
        return 1;
    }
}
