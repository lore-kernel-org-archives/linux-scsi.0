From: christophe varoqui <christophe.varoqui@free.fr>
Subject: RE: [dm-devel] [ANNOUNCE] multipath-tools-0.4.1
Date: Wed, 22 Dec 2004 22:52:34 +0100
Message-ID: <1103752354.7432.4.camel@zezette>
References: <EA4DC661A6353747A2E5C0DE8792DDDE07501278@orsmsx404.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp4.wanadoo.fr ([193.252.22.27]:64182 "EHLO smtp4.wanadoo.fr")
	by vger.kernel.org with ESMTP id S262019AbULVToS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2004 14:44:18 -0500
In-Reply-To: <EA4DC661A6353747A2E5C0DE8792DDDE07501278@orsmsx404.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le mercredi 22 d?embre 2004 =C3=A0 11:26 -0800, Caushik, Ramesh a =C3=A9=
crit :
> On my system I have a Qlogic 2310 driver running on a 2.6.9 kernel. T=
he fc_transport=20
> directory in sysfs looks like=20
>=20
> ls -ll /sys/class/fc_transport/
> total 0
> drwxr-xr-x   6 root root 0 Dec 16 13:59 .
> drwxr-xr-x  20 root root 0 Dec 15 14:31 ..
> drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:0:0
> drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:1:0
> drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:2:0
> drwxr-xr-x   2 root root 0 Dec 16 13:59 2:0:3:0 =20
>=20
> The patch addresses only this format. So please disregard the patch, =
and sorry about the confusion.
>=20
=2E..
> [root@cl039 multipath]# ll /sys/class/fc_transport/
> total 0
> drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:0
> drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:1
> drwxr-xr-x    2 root     root            0 Dec 14 16:26 target2:0:2
> drwxr-xr-x    2 root     root            0 Dec 14 16:27 target2:0:3
> drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:0
> drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:1
> drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:2
> drwxr-xr-x    2 root     root            0 Dec 14 16:27 target3:0:3
>=20
Can someone, maybe from Qlogic, comment on these differences ?
Is there a grant unified plan for driver objects representation through
sysfs, and if so which is the right path name to fetch the node_name.

regards,
--=20
christophe varoqui <christophe.varoqui@free.fr>


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
