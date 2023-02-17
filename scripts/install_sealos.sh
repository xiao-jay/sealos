#!/bin/bash
ARCH=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/)
echo "ARCH: $ARCH"

i=1

while (( $i <= 3 ))  ;
do
    if [ ! -f "go1.20.1.linux-$ARCH.tar.gz" ]; then
        wget https://go.dev/dl/go1.20.1.linux-$ARCH.tar.gz
         ((i++))
    else
        break
    fi
done

if [ ! -f "go1.20.1.linux-$ARCH.tar.gz" ]; then
    echo "wget go file fail"
    exit 1
fi

tar -C /usr/local -zxvf go1.20.1.linux-$ARCH.tar.gz
cat >> /etc/profile <<EOF
# set go path
export PATH=\$PATH:/usr/local/go/bin
EOF
source /etc/profile  && go version
apt-get update
apt install make gcc -y


i=1
while (( $i <= 3 ))  ;
do
    if [ ! -e "sealos" ]; then
        git clone https://github.com/labring/sealos.git
         ((i++))
    else
        break
    fi
done

if [ ! -e "sealos" ]; then
    echo "clone sealos fail"
    exit 1
fi


cd sealos
export GOPROXY=https://goproxy.io,direct
go mod tidy
make build BINS=sealos
mv bin/linux_$ARCH/sealos  /usr/local/bin
sealos version