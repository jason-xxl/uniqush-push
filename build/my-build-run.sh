#!/bin/sh

cd uniqush-push
git add .
git commit -am"+sth"
git push

cd ..

TEMP=`pwd`/tmpgopath
LICENSE=Apache-2.0

rm -rf $TEMP
rm -rf *.deb
rm -rf *.rpm
rm -rf *.tar.gz
rm -rf uniqush-push_1.4.1_x86_64


mkdir -p $TEMP/bin
mkdir -p $TEMP/src
mkdir -p $TEMP/pkg

GOBIN=$TEMP/bin GOPATH=$TEMP go get github.com/jason-xxl/uniqush-push

VERSION=`$TEMP/bin/uniqush-push --version | sed 's/uniqush-push //'`

BUILD=`pwd`/uniqush-push-$VERSION
mkdir -p $BUILD/usr/bin
mkdir -p $BUILD/etc/uniqush/

#ARCH=`uname -m`
ARCH="x86_64"


cp $TEMP/bin/uniqush-push $BUILD/usr/bin
cp $TEMP/src/github.com/jason-xxl/uniqush-push/conf/uniqush-push.conf $BUILD/etc/uniqush
cp $TEMP/src/github.com/jason-xxl/uniqush-push/LICENSE $LICENSE

fpm -s dir -t rpm -v $VERSION -n uniqush-push --license=$LICENSE --maintainer="Nan Deng" -d redis --vendor "uniqush" --url="http://uniqush.org" --category Network --description "Uniqush is a free and open source software which provides a unified push service for server-side notification to apps on mobile devices" -a $ARCH -C $BUILD .

fpm -s dir -t deb -v $VERSION -n uniqush-push --license=$LICENSE --maintainer="Nan Deng" -d redis-server --vendor "uniqush" --url="http://uniqush.org" --category Network --description "Uniqush is a free and open source software which provides a unified push service for server-side notification to apps on mobile devices" -a $ARCH -C $BUILD .

TARBALLNAME=uniqush-push_${VERSION}_$ARCH
TARBALLDIR=`pwd`/$TARBALLNAME
mkdir -p $TARBALLDIR
cp $LICENSE $TARBALLDIR
cp $TEMP/bin/uniqush-push $TARBALLDIR
cp $TEMP/src/github.com/jason-xxl/uniqush-push/conf/uniqush-push.conf $TARBALLDIR/uniqush-push.conf

cat > $TARBALLNAME/install.sh << EOF
#!/bin/sh
mkdir -p /etc/uniqush
cp uniqush-push /usr/local/bin
cp uniqush-push.conf /etc/uniqush
echo "Success!"
EOF

chmod +x $TARBALLDIR/install.sh
tar czvf $TARBALLNAME.tar.gz $TARBALLNAME

rm -rf $BUILD
rm -rf $TARBALLDIR
#rm -f uniqush-push
rm -f uniqush-push.conf
rm -f $LICENSE 

tar zxvf uniqush-push_1.4.1_x86_64.tar.gz

echo "server started."
./uniqush-push_1.4.1_x86_64/uniqush-push -config="./uniqush-push_1.4.1_x86_64/uniqush-push.conf"





