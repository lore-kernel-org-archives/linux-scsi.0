From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Pb with external RAID controller in lk 2.4
Date: Tue, 21 May 2002 21:03:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CEAEE48.6DEFAE4D@torque.net>
References: <20020522014953.L2011-100000@localhost.my.domain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?G=E9rard?= Roudier <groudier@free.fr>
Cc: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org, Lorraine Suschetet <lorraine@ext.cri74.org>

G=E9rard Roudier wrote:
>=20
> A lun limitation is hardcoded in /usr/src/linux/drivers/scsi/scsi.c.
> here's the offending lines:
>=20
> #ifdef CONFIG_SCSI_MULTI_LUN
> static int max_scsi_luns =3D 8;
> #else
> static int max_scsi_luns =3D 1;
> #endif
>=20
> You want to change value 8 by some higher value. It has chance to wor=
k.

You can set "max_scsi_luns" as a kernel boot time parameter
(e.g. with lilo add the line 'append "max_scsi_luns=3D16"') when
the scsi mid level is built in to the kernel. If the scsi mid
level is a module then the same argument can be given when that
module is loaded (or via /etc/modules.conf).

Doug Gilbert

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
