// Copyright (C) 2013-2014 Thalmic Labs Inc.
// Distributed under the Myo SDK license agreement. See LICENSE.txt for details.
#define _USE_MATH_DEFINES
#include <cmath>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <stdexcept>
#include <string>

// The only file that needs to be included to use the Myo C++ SDK is myo.hpp.
#include <myo/myo.hpp>

// Classes that inherit from myo::DeviceListener can be used to receive events from Myo devices. DeviceListener
// provides several virtual functions for handling different kinds of events. If you do not override an event, the
// default behavior is to do nothing.
class DataCollector : public myo::DeviceListener {
public:
    DataCollector()
    : onArm(false), roll_w(0), pitch_w(0), yaw_w(0), roll_r(0.0), pitch_r(0.0), yaw_r(0.0), accel_time(0.0), ang_accel_time(0.0), last_impact_time(0.0), currentPose()
    {
    }

    // onUnpair() is called whenever the Myo is disconnected from Myo Connect by the user.
    void onUnpair(myo::Myo* myo, uint64_t timestamp)
    {
        // We've lost a Myo.
        // Let's clean up some leftover state.
        roll_w = 0;
        pitch_w = 0;
        yaw_w = 0;
        roll_r = 0.0;
        pitch_r = 0.0;
        yaw_r = 0.0;
        onArm = false;
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
        
		acceleration = myo::Vector3<float>(accel.x() - gravity.x(),
                                           accel.y() - gravity.y(),
                                           accel.z() - gravity.z());
        
        
        accel_time = timestamp;
        
		// calculate the magnitude of the acceleration
		float acc_mag = sqrt(acceleration.x()*acceleration.x() +
                       acceleration.y()*acceleration.y() + 
                       acceleration.z()*acceleration.z());
        
        if (acc_mag > 0.65 && acceleration.x() < 0) {
            if (timestamp - last_impact_time < 200000 /* ns */)
                return;
            last_impact_time = timestamp;
            float up = acceleration.z();
            float down = -acceleration.z();
            float right = acceleration.y();
            float left = -acceleration.y();
            
            if (up > down && up > right && up > left) {
                std::cout << "up ";
            } else if (down > up && down > right && down > left) {
                std::cout << "down ";
            } else if (right > up && right > down && right > left) {
                std::cout << "right ";
            } else if (left > up && left > down && left > right) {
                std::cout << "left ";
            }
            std::cout << "accel" << acceleration.x() << ", " << acceleration.y() << ", " << acceleration.z() << std::endl;
            std::cout << "pitch:" << pitch_r << " roll:" << roll_r << " yaw:" << yaw_r << std::endl;
            
        }
	}
    
    // onGyroscopeData() is called whenever the Myo device provides new gyroscope data,
	// representing the angular velocity in units of deg/s
	void onGyroscopeData(myo::Myo *myo, uint64_t timestamp, const myo::Vector3< float > &gyro)
	{
		using std::sqrt;
        
        ang_accel = gyro;
        ang_accel_time = timestamp;
        
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

        // Calculate Euler angles (roll, pitch, and yaw) from the unit quaternion.
        roll_r = atan2(2.0f * (quat.w() * quat.x() + quat.y() * quat.z()),
                           1.0f - 2.0f * (quat.x() * quat.x() + quat.y() * quat.y()));
        pitch_r = asin(2.0f * (quat.w() * quat.y() - quat.z() * quat.x()));
        yaw_r = atan2(2.0f * (quat.w() * quat.z() + quat.x() * quat.y()),
                        1.0f - 2.0f * (quat.y() * quat.y() + quat.z() * quat.z()));

        // Convert the floating point angles in radians to a scale from 0 to 20.
        roll_w = static_cast<int>((roll_r + (float)M_PI)/(M_PI * 2.0f) * 18);
        pitch_w = static_cast<int>((pitch_r + (float)M_PI/2.0f)/M_PI * 18);
        yaw_w = static_cast<int>((yaw_r + (float)M_PI)/(M_PI * 2.0f) * 18);
        
        orientation_time = timestamp;
    }

    // onPose() is called whenever the Myo detects that the person wearing it has changed their pose, for example,
    // making a fist, or not making a fist anymore.
    void onPose(myo::Myo* myo, uint64_t timestamp, myo::Pose pose)
    {
        currentPose = pose;

        // Vibrate the Myo whenever we've detected that the user has made a fist.
        if (pose == myo::Pose::fist) {
            myo->vibrate(myo::Myo::vibrationMedium);
        }
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
        
		myfile
        << accel_time << ","
        << acceleration.x() << "," << acceleration.y() << "," << acceleration.z() << ","
        << ang_accel_time << ","
        << ang_accel.x() << "," << ang_accel.y() << "," << ang_accel.z() << ","
        << orientation_time << ","
        << roll_r << "," << pitch_r << "," << yaw_r << ","
        << gravity.x() << "," << gravity.y() << "," << gravity.z() << "\n"
        << std::flush;
    }

    // These values are set by onArmRecognized() and onArmLost() above.
    bool onArm;
    myo::Arm whichArm;

    // These values are set by onOrientationData() and onPose() above.
    int roll_w, pitch_w, yaw_w;
    float roll_r, pitch_r, yaw_r;
    
    int64_t last_impact_time;
    int64_t accel_time, ang_accel_time, orientation_time;
	myo::Vector3<float> acceleration;
    myo::Vector3<float> ang_accel;
    myo::Vector3<float> gravity;
    myo::Pose currentPose;
    
    std::ofstream myfile;
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
    collector.myfile << "accel_time,accel_x,accel_y,accel_z,ang_accel_time,ang_x,ang_y,ang_z,orientation_time,roll,pitch,yaw,gravity_x,gravity_y,gravity_z\n";

    // Finally we enter our main loop.
    while (1) {
        // In each iteration of our main loop, we run the Myo event loop for a set number of milliseconds.
        // In this case, we wish to update our display 20 times a second, so we run for 1000/20 milliseconds.
        hub.run(20);
        // After processing events, we call the print() member function we defined above to print out the values we've
        // obtained from any events that have occurred.
        collector.print();
    }

    // If a standard exception occurred, we print out its message and exit.
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        std::cerr << "Press enter to continue.";
        std::cin.ignore();
        return 1;
    }
}
