#!/bin/sh

# 获取设备的总线号和设备号（通过匹配设备名“FM350-GL”）
BUS_DEVICE=$(lsusb | grep "FM350-GL" | awk '{print $2 "-" $4}' | sed 's/://g' | sed 's/0//g')

# 获取总线号和设备号
BUS=$(echo $BUS_DEVICE | cut -d'-' -f1)
DEVICE=$(echo $BUS_DEVICE | cut -d'-' -f2)

# 如果没有找到设备，退出脚本
if [ -z "$BUS" ] || [ -z "$DEVICE" ]; then
    echo "设备 FM350-GL 未找到"
    exit 1
fi

# 确认设备路径是否存在
DEVICE_PATH="/sys/bus/usb/devices/$BUS-$DEVICE"
if [ ! -d "$DEVICE_PATH" ]; then
    echo "设备路径 $DEVICE_PATH 不存在，设备可能已被移除或未连接"
    exit 1
fi

# 输出调试信息，确认总线号和设备号
echo "Bus: $BUS, Device: $DEVICE"

# 断开设备
echo "$BUS-$DEVICE" > /sys/bus/usb/drivers/usb/unbind

# 等待一会儿（可选）
sleep 1

# 重新连接设备
echo "$BUS-$DEVICE" > /sys/bus/usb/drivers/usb/bind

