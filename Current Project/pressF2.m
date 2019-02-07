function pressF2()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
 robot = java.awt.Robot;
 robot.keyPress    (java.awt.event.KeyEvent.VK_F2);
 robot.keyRelease    (java.awt.event.KeyEvent.VK_F2);
end

