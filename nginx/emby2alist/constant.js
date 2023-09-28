// export constant allocation
// 根据实际情况修改下面的设置

// 这里默认emby/jellyfin的地址是宿主机,要注意iptables给容器放行端口
const embyHost = "http://192.168.50.2:8096";
// rclone 的挂载目录, 例如将od, gd挂载到/mnt目录下:  /mnt/onedrive  /mnt/gd ,那么这里 就填写 /mnt
const embyMountPath = "/media/alist";
// alist token, 在alist后台查看
const alistToken = "alist-a9b0e88e-c15a-4368-b0a1-52458f8bb52asad7XgklfVEc02axf0JcOFCqhFKNWTayHi9VMCV7TfzUpQ293gx9zMycvajw3z4J";
// 访问宿主机上5244端口的alist地址, 要注意iptables给容器放行端口
const alistAddr = "http://192.168.50.2:5244";
// emby/jellyfin api key, 在emby/jellyfin后台设置
const embyApiKey = "c4d1d91dde454163b7b43d429bb002b0";
// alist公网地址, 用于需要alist server代理流量的情况, 按需填写
const alistPublicAddr = "http://192.168.50.2:5244";

// alist 登陆用户和密码
const alistUserName = `admin`
const alistPwd = `''''`

export default {
    embyHost,
    embyMountPath,
    alistToken,
    alistAddr,
    embyApiKey,
    alistPublicAddr,
    alistUserName,
    alistPwd
}
