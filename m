From: Douglas Gilbert <dougg@torque.net>
Subject: Re: advansys modules fails to compile in 2.5.8-pre3
Date: Thu, 11 Apr 2002 23:30:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CB654C1.844C9A0B@torque.net>
References: <Pine.LNX.4.44.0204120212450.1853-100000@grignard.amagerkollegiet.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rasmus =?iso-8859-1?Q?B=F8g?= Hansen <moffe@amagerkollegiet.dk>
Cc: linux-scsi@vger.kernel.org

Rasmus,

Point 1)
Here is a tarball of driver/scsi/advansys.[hc]
taken from lk 2.5.7-dj3. It is a bit big to attach
so you can fetch it here:
http://www.torque.net/sg/p/advansys257dj3.tgz

My advansys fix has been in Dave Jones's tree for nearly
2 months now (along with a lot of other SCSI fixes and
enhancements). Maybe if we said we were introducing a
new IO subsystem called the "small computer system
interface" we might be more successful having our patches
accepted :-)

Point 2)
=46rom advansys.c:
 * As of March 8, 2000 Advanced System Products, Inc. (AdvanSys)
 * changed its name to ConnectCom Solutions, Inc.

Then if you go to www.connectcom.net you get told that
advansys has been taken over by initio.

Doug Gilbert


Rasmus B=F8g Hansen wrote:
>=20
> Hi
>=20
> Two things:
>=20
> When I try to compile kernel 2.5.8-pre3, I get this error:
>=20
> gcc -D__KERNEL__ -I/tmp/linux-2.5.7/include -Wall -Wstrict-prototypes
> -Wno-trigraphs -O2 -fomit-frame-pointer -fno-strict-aliasing -fno-com=
mon
> -pipe -mpreferred-stack-boundary=3D2 -march=3Dathlon  -DMODULE
> -DKBUILD_BASENAME=3Dadvansys  -c -o advansys.o advansys.c
> advansys.c:755:2: #error Please convert me to
> Documentation/DMA-mapping.txt
> advansys.c: In function `asc_build_req':
> advansys.c:6754: structure has no member named `address'
> advansys.c:6754: structure has no member named `address'
> advansys.c: In function `adv_get_sglist':
> advansys.c:7014: structure has no member named `address'
> advansys.c:7014: structure has no member named `address'
> make[2]: *** [advansys.o] Error 1
> make[2]: Leaving directory `/tmp/linux-2.5.7/drivers/scsi'
> make[1]: *** [_modsubdir_scsi] Error 2
> make[1]: Leaving directory `/tmp/linux-2.5.7/drivers'
> make: *** [_mod_drivers] Error 2
>=20
> The error seems pretty obvious; the DMA interface changed -
> unfortunately I do not know anything about DMA...
>=20
> One more thing:
>=20
> In MAINTAINERS is this maintainer information about the advansys driv=
er:
>=20
> W:      http://www.advansys.com/linux.html
>=20
> This web page does not exist. This error is common for 2.4.18 and
> 2.5.8-pre3.
>=20
> Regards
> /Rasmus
>=20
> --
> -- [ Rasmus "M=F8ffe" B=F8g Hansen ] --------------------------------=
-------
> Beware of programmers who carry screwdrivers
> ----------------------------------[ moffe at amagerkollegiet dot dk ]=
 --
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
