From: angus <angus@mcm.net>
Subject: 2.5.14 error: ini9100u.c
Date: 06 May 2002 11:00:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1020675649.20692.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Just a bug report of compilation which perdure since several 2.5 releas=
e
concerning the driver of initio scsi card and which prevents me from
testing any 2.5.x :(

Please CC: back to me, as I'm not subscribed.
Any help welcome, even bearers of bad news :)


gcc -D__KERNEL__ -I/usr/src/linux-2.5.14/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fomit-frame-pointer
-fno-strict-aliasing -fno-common -pipe -mpreferred-stack-boundary=3D2
-march=3Dk6 -DMODULE -DMODVERSIONS -include
/usr/src/linux-2.5.14/include/linux/modversions.h=20
-DKBUILD_BASENAME=3Dini9100u  -c -o ini9100u.o ini9100u.c
ini9100u.c:111:2: #error Please convert me to
Documentation/DMA-mapping.txt
ini9100u.c: In function `i91uBuildSCB':
ini9100u.c:494: structure has no member named `address'
ini9100u.c:503: structure has no member named `address'
make[2]: *** [ini9100u.o] Erreur 1
make[2]: Quitte le r=E9pertoire `/usr/src/linux-2.5.14/drivers/scsi'
make[1]: *** [_modsubdir_scsi] Erreur 2
make[1]: Quitte le r=E9pertoire `/usr/src/linux-2.5.14/drivers'
make: *** [_mod_drivers] Erreur 2

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
