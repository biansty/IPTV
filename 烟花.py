import pygame as pg
import random as ra
import math
pg.init()
pg.display.set_caption("🎇")
winScreen = pg.display.Info()
screenWidth = winScreen.current_w
screenHeight = winScreen.current_h
vector = pg.math.Vector2
trail_colors = [(45, 45, 45), (60, 60, 60), (75, 75, 75), (125, 125, 125), (150, 150, 150)]
# 烟花类
class Firework:
    def __init__(self):
        # 随机生成颜色
        self.colour = (ra.randint(0, 255), ra.randint(0, 255), ra.randint(0, 255))
        # 随机生成三种颜色
        self.colours = (
            (ra.randint(0, 255), ra.randint(0, 255), ra.randint(0, 255)),
            (ra.randint(0, 255), ra.randint(0, 255), ra.randint(0, 255)),
            (ra.randint(0, 255), ra.randint(0, 255), ra.randint(0, 255))
        )
        # 生成一个表示发射出的火花的粒子对象
        self.firework = Particle(ra.randint(0,screenWidth), screenHeight, True, self.colour)
        # 初始化爆炸状态为 False
        self.exploded = False
        self.particles = []
        # 爆炸产生的粒子数量范围
        self.min_max_particles = vector(666, 999)
    def update(self, win):
        g = vector(0, ra.uniform(0.15, 0.4))
        if not self.exploded:
            # 给发射出的火花施加重力
            self.firework.apply_force(g)
            self.firework.move()
            for tf in self.firework.trails:
                tf.show(win)
            self.show(win)
            if self.firework.vel.y >= 0:
                self.exploded = True
                self.explode()
        else:
            for particle in self.particles:
                # 给爆炸产生的粒子施加随机力
                particle.apply_force(vector(g.x + ra.uniform(-1, 1) / 20, g.y / 2 + (ra.randint(1, 8) / 100)))
                particle.move()
                for t in particle.trails:
                    t.show(win)
                particle.show(win)
    def explode(self):
        amount = ra.randint(int(self.min_max_particles.x), int(self.min_max_particles.y))
        for i in range(amount):
            # 在爆炸位置生成粒子对象并添加到粒子列表中
            self.particles.append(Particle(self.firework.pos.x, self.firework.pos.y, False, self.colours))
    def show(self, win):
        # 绘制发射出的火花
        pg.draw.circle(win, self.colour, (int(self.firework.pos.x), int(self.firework.pos.y)), self.firework.size)
    def remove(self):
        if self.exploded:
            for p in self.particles:
                if p.remove is True:
                    self.particles.remove(p)
            if len(self.particles) == 0:
                return True
            else:
                return False
# 粒子类
class Particle:
    def __init__(self, x, y, firework, colour):
        self.firework = firework
        self.pos = vector(x, y)
        self.origin = vector(x, y)
        self.radius = 25
        self.remove = False
        self.explosion_radius = ra.randint(15, 25)
        self.life = 0
        self.acc = vector(0, 0)
        self.trails = []
        self.prev_posx = [-10] * 10
        self.prev_posy = [-10] * 10
        if self.firework:
            self.vel = vector(0, -ra.randint(17, 20))
            self.size = 5
            self.colour = colour
            for i in range(5):
                self.trails.append(Trail(i, self.size, True))
        else:
            self.vel = vector(ra.uniform(-1, 1), ra.uniform(-1, 1))
            self.vel.x *= ra.randint(7, self.explosion_radius + 2)
            self.vel.y *= ra.randint(7, self.explosion_radius + 2)
            self.size = ra.randint(2, 4)
            self.colour = ra.choice(colour)
            for i in range(5):
                self.trails.append(Trail(i, self.size, False))
    def apply_force(self, force):
        # 施加力
        self.acc += force
    def move(self):
        if not self.firework:
            # 爆炸产生的粒子减速
            self.vel.x *= 0.8
            self.vel.y *= 0.8
        self.vel += self.acc
        self.pos += self.vel
        self.acc *= 0
        if self.life == 0 and not self.firework:
            # 判断是否超出爆炸半径
            distance = math.sqrt((self.pos.x - self.origin.x) ** 2 + (self.pos.y - self.origin.y) ** 2)
            if distance > self.explosion_radius:
                self.remove = True
        self.decay()
        self.trail_update()
        self.life += 1
    def show(self, win):
        # 绘制粒子
        pg.draw.circle(win, (self.colour[0], self.colour[1], self.colour[2], 0), (int(self.pos.x), int(self.pos.y)), self.size)
    def decay(self):
        if 50 > self.life > 10:
            ran = ra.randint(0, 30)
            if ran == 0:
                self.remove = True
        elif self.life > 50:
            ran = ra.randint(0, 5)
            if ran == 0:
                self.remove = True
    def trail_update(self):
        self.prev_posx.pop()
        self.prev_posx.insert(0, int(self.pos.x))
        self.prev_posy.pop()
        self.prev_posy.insert(0, int(self.pos.y))
        for n, t in enumerate(self.trails):
            if t.dynamic:
                t.get_pos(self.prev_posx[n + 1], self.prev_posy[n + 1])
            else:
                t.get_pos(self.prev_posx[n + 5], self.prev_posy[n + 5])
# 痕迹类
class Trail:
    def __init__(self, n, size, dynamic):
        self.pos_in_line = n
        self.pos = vector(-10, -10)
        self.dynamic = dynamic
        if self.dynamic:
            self.colour = trail_colors[n]
            self.size = int(size - n / 2)
        else:
            self.colour = (255, 255, 200)
            self.size = size - 2
            if self.size < 0:
                self.size = 0
    def get_pos(self, x, y):
        self.pos = vector(x, y)
    def show(self, win):
        # 绘制痕迹
        pg.draw.circle(win, self.colour, (int(self.pos.x), int(self.pos.y)), self.size)
def update(win, fireworks):
    for fw in fireworks:
        fw.update(win)
        if fw.remove():
            fireworks.remove(fw)
    pg.display.update()
def fire():
    screen = pg.display.set_mode((screenWidth, screenHeight - 66))
    clock = pg.time.Clock()
    fireworks = [Firework() for i in range(2)]
    running = True
    # 加载字体
    font = pg.font.SysFont("comicsansms", 99)
    # 渲染文本
    text = "Happy New Year!"
    text_color = (255, 190, 200)  # 字体颜色
    rendered_text = font.render(text, True, text_color)
    while running:
        clock.tick(99)
        for event in pg.event.get():
            if event.type == pg.QUIT:
                running = False
        # 计算文本位置
        text_width = rendered_text.get_width()
        text_height = rendered_text.get_height()
        text_x = (screenWidth - text_width) // 2
        text_y = (screenHeight - text_height) // 2 - 99
        screen.fill((20, 20, 30))
        # 绘制文本
        screen.blit(rendered_text, (text_x, text_y))
        if ra.randint(0, 10) == 1:
            fireworks.append(Firework())
        update(screen, fireworks)
    pg.quit()
    quit()
if __name__ == "__main__":
    fire()
