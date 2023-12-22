import tkinter as tk
import time

def update_clock():
    current_time = time.strftime("%H:%M:%S")
    clock_label.config(text=current_time)
    clock_label.after(1000, update_clock)

# 创建主窗口
window = tk.Tk()
window.title("数字时钟")

# 创建标签来显示时间
clock_label = tk.Label(window, font=("Arial", 80), bg="white", fg="black")
clock_label.pack(pady=50)

# 更新时钟
update_clock()

# 运行主循环
window.mainloop()
