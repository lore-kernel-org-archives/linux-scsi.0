From: =?iso-8859-1?Q?Rasmus_B=F8g_Hansen?= <moffe@amagerkollegiet.dk>
Subject: advansys modules fails to compile in 2.5.8-pre3
Date: Fri, 12 Apr 2002 02:19:37 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204120212450.1853-100000@grignard.amagerkollegiet.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux@advansys.com
Cc: linux-scsi@vger.kernel.org

Hi

Two things:

When I try to compile kernel 2.5.8-pre3, I get this error:

gcc -D__KERNEL__ -I/tmp/linux-2.5.7/include -Wall -Wstrict-prototypes=20
-Wno-trigraphs -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-commo=
n=20
-pipe -mpreferred-stack-boundary=3D2 -march=3Dathlon  -DMODULE =20
-DKBUILD_BASENAME=3Dadvansys  -c -o advansys.o advansys.c
advansys.c:755:2: #error Please convert me to=20
Documentation/DMA-mapping.txt
advansys.c: In function `asc_build_req':
advansys.c:6754: structure has no member named `address'
advansys.c:6754: structure has no member named `address'
advansys.c: In function `adv_get_sglist':
advansys.c:7014: structure has no member named `address'
advansys.c:7014: structure has no member named `address'
make[2]: *** [advansys.o] Error 1
make[2]: Leaving directory `/tmp/linux-2.5.7/drivers/scsi'
make[1]: *** [_modsubdir_scsi] Error 2
make[1]: Leaving directory `/tmp/linux-2.5.7/drivers'
make: *** [_mod_drivers] Error 2

The error seems pretty obvious; the DMA interface changed -=20
unfortunately I do not know anything about DMA...

One more thing:

In MAINTAINERS is this maintainer information about the advansys driver=
:

W:      http://www.advansys.com/linux.html

This web page does not exist. This error is common for 2.4.18 and=20
2.5.8-pre3.

Regards
/Rasmus

--=20
-- [ Rasmus "M=F8ffe" B=F8g Hansen ] ----------------------------------=
-----
Beware of programmers who carry screwdrivers
----------------------------------[ moffe at amagerkollegiet dot dk ] -=
-

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
