From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: Problem with megaraid and PERC3/dc on a poweredge 6450
Date: Wed, 5 Jan 2005 12:07:06 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57058C00B5@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53647 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261837AbVAERHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2005 12:07:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Stefan Berder' <sbe@oleane.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Please attach the dmesg output from the megaraid_mm and megaraid_mbox
drivers as well. Also, all files from /proc/megaraid2 directory from 2.=
4
kernel driver

Thanks
-Atul Mukker
LSI Logic Corporation=20

> -----Original Message-----
> From: Stefan Berder [mailto:sbe@oleane.net]=20
> Sent: Wednesday, January 05, 2005 11:50 AM
> To: linux-scsi@vger.kernel.org
> Subject: Problem with megaraid and PERC3/dc on a poweredge 6450
>=20
> Hi all,
> I got some strange problems with the megaraid driver under linux.
> The box I'm running is a dell poweredge 6450 with a PERC3/DC=20
> raid controller and Adaptec AIC-7899P controllers. I got=20
> 2x36GB (RAID1) scsi hdd inside the box an 13x36GB (RAID5) in=20
> a dell hdd bay, debian sarge is the system.
>=20
> I got various problems :
> - I found a debian install iso on the linux.dell;com site to=20
> install the box. It's a 2.4.28 kernel, and the box is working=20
> fine with this kernel.
> When I switch to a 2.4.28 kernel based on the configuration=20
> file provided with the install kernel and removing some=20
> useless things, adding netfilter, the box boots but hdds got=20
> really poor performances :
> brucelee:~/src# hdparm -t -T /dev/sda /dev/sdb
>=20
> /dev/sda:
>  Timing cached reads:   724 MB in  2.00 seconds =3D 362.00 MB/sec
>  Timing buffered disk reads:   12 MB in  3.56 seconds =3D   3.37 MB/s=
ec
>=20
> /dev/sdb:
>  Timing cached reads:   668 MB in  2.00 seconds =3D 334.00 MB/sec
>  Timing buffered disk reads:   12 MB in  3.19 seconds =3D   3.76 MB/s=
ec
>=20
> - When I compile a 2.6.10 kernel, I got 2 problems, first=20
> when I use the megaraid legacy I get a kernel panic during=20
> boot with something about "data cache" before. When I use the=20
> new megaraid (megaraid_mm and
> megaraid_mbox) during the kernel scsi probe it says that some=20
> command hangs and timeouts, then it does a lot of timeouts...
>=20
> lspci and dmesg attached
> --=20
>  #=3D- Stefan Berder                  tel : 6 14 80        -=3D#
>  #=3D- Ing=E9nieur syst=E8me et r=E9seau          01 53 95 14 80 -=3D=
#
>  #=3D- TRANSPAC / DO-DAE-ADMG        mail : sbe@oleane.net -=3D#
>  #=3D- /(bb|[^b]{2})/      stefan.berder@francetelecom.com -=3D#
>=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
