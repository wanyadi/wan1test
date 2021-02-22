#!/bin/bash
source /etc/profile
##set color##
echoRed() { echo $'\e[0;31m'"$1"$'\e[0m'; }
echoGreen() { echo $'\e[0;32m'"$1"$'\e[0m'; }
echoYellow() { echo $'\e[0;33m'"$1"$'\e[0m'; }
##set color##  #project="ruibo-sso-ui"
version=1.0.0
env=fn
project=瑞波ERP定制版-feely-crm-fn
#jiqi=zjk-pre-dev4
name=feely-crm
ali_ns=ruibo-fn
context=c-zphtv:p-5wmmp
rancher_token=*****
#环境变量
port=8091
s_dubbo=zk-url:2181
s_nacos=nacosurl:80
s_namespace=49d000b9-7b2c-4c05-9ab7-99d******
s_spring=default
s_Xmx=2048m
s_Xms=2048m
s_Xmn=512m

cd /home/jenkins-slave-docker/workspace/${project}/ && mv -f ${name}-web/target/${name}-web.jar ./app.jar

#Docker打包
cat << EOF > entrypoint.sh
#!/bin/bash
cd /mnt/work/$name/
EOF
cat << 'EOF' >> entrypoint.sh
#!/bin/bash
#获取setting.conf参数
dubbo_addr=`grep dubbo setting.conf | cut -d= -f2`
nacos_addr=`grep nacos setting.conf | cut -d= -f2`
nacos_namespace=`grep namespace setting.conf | cut -d= -f2`
spring_active=`grep spring setting.conf | cut -d= -f2`
Xmx=`grep Xmx setting.conf | cut -d= -f2`
Xms=`grep Xms setting.conf | cut -d= -f2`
Xmn=`grep Xmn setting.conf | cut -d= -f2`
java -Xmx${Xmx} -Xms${Xms} -Xmn${Xmn} -XX:NewRatio=${NewRatio} -XX:NativeMemoryTracking=${NativeMemoryTracking} -XX:MaxDirectMemorySize=${MaxDirectMemorySize} -XX:SurvivorRatio=${SurvivorRatio} -XX:MetaspaceSize=${MetaspaceSize}  -XX:MaxMetaspaceSize=${MaxMetaspaceSize} -XX:MaxTenuringThreshold=${MaxTenuringThreshold} -XX:ParallelGCThreads=${ParallelGCThreads} -XX:ConcGCThreads=${ConcGCThreads} ${other} -XX:HeapDumpPath=${HeapDumpPath} -jar ${jar} ${log} ${other2} --dubbo.registry.address=${dubbo_addr} --spring.cloud.nacos.config.server-addr=${nacos_addr} --spring.cloud.nacos.config.namespace=${nacos_namespace} --spring.profiles.active=${spring_active}
EOF

cat > setting.conf << EOF
#连接配置
dubbo=$s_dubbo
nacos=$s_nacos
namespace=$s_namespace
spring=$s_spring
#JAVA参数
Xmx=$s_Xmx
Xms=$s_Xms
Xmn=$s_Xmn
EOF

chmod +x entrypoint.sh app.jar

cat >Dockerfile << EOF
FROM zhegeshijiehuiyouai/java:1.8
#other是所有没有等号的参数，other2是为了以后扩展用的
ENV NewRatio=4 NativeMemoryTracking=detail MaxDirectMemorySize=1024m SurvivorRatio=8 \
    MetaspaceSize=512m MaxMetaspaceSize=512m MaxTenuringThreshold=15 ParallelGCThreads=8 ConcGCThreads=8 \
    HeapDumpPath="dump/error.dump" jar="/mnt/work/$name/app.jar" log="--logging.file=/mnt/work/$name/log/$name.log" \
    other="-XX:+UseG1GC -XX:+DisableExplicitGC -XX:+HeapDumpOnOutOfMemoryError" other2=""
ADD app.jar /mnt/work/$name/
ADD setting.conf /mnt/work/$name/
ADD entrypoint.sh /
EXPOSE $port
ENTRYPOINT ["/entrypoint.sh"]
EOF

#首先删除容器，不然无法删除镜像
docker ps -a | grep ${name} &> /dev/null && docker rm -f ${name}
docker rmi -f $name-$env:$BUILD_NUMBER
#构建镜像，镜像名还是原来的
echoGreen "开始构建当次镜像！"
docker build -t $name-$env:$BUILD_NUMBER .
#打tag
docker rmi -f *****.aliyuncs.com/$ali_ns/$name-$env:$BUILD_NUMBER
docker tag $name-$env:$BUILD_NUMBER *****.aliyuncs.com/$ali_ns/$name-$env:$BUILD_NUMBER
#上传到阿里（张北3）
docker push *****.aliyuncs.com/$ali_ns/$name-$env:$BUILD_NUMBER

#删除镜像
docker rmi -f $name-$env:$BUILD_NUMBER
docker rmi -f *****.aliyuncs.com/$ali_ns/$name-$env:$BUILD_NUMBER

#更新rancher环境镜像
rancher login https://rancherurl/v3 --token token-xvjsf:$rancher_token --context $context
rancher kubectl set image deploy -n=$env $name-$env $name-$env=*****.aliyuncs.com/$ali_ns/$name-$env:$BUILD_NUMBER --record
