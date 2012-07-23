From: "Jack Wang" <jack_wang@usish.com>
Subject: RE question about  path_id of scsi hard disk
Date: Mon, 23 Jul 2012 11:25:16 +0800
Message-ID: <C49F8C68952B4B6B97FA5941E9C68CE0@usish.com.cn>
References: <op.whqka8y2n27o5l@gaoqiang-d1.corp.qihoo.net> <1342823514.2984.48.camel@dabdike.int.hansenpartnership.com> <op.whvpuyesn27o5l@gaoqiang-d1.corp.qihoo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:41251 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959Ab2GWDYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2012 23:24:23 -0400
In-Reply-To: <op.whvpuyesn27o5l@gaoqiang-d1.corp.qihoo.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'gaoqiang' <gaoqiangscut@gmail.com>, 'James Bottomley' <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

> =D4=DA Sat, 21 Jul 2012 06:31:54 +0800=A3=ACJames Bottomley
> <James.Bottomley@hansenpartnership.com> =D0=B4=B5=C0:
>=20
> > On Fri, 2012-07-20 at 16:24 +0800, gaoqiang wrote:
> >> I'm using udev to manage my hard disks. but I'm confusing
> >> about the "PATH_ID"
> >>
> >> gaoqiang@h150:~$/lib/udev/path_id  /block/sda
> >> ID_PATH=3Dpci-0000:01:00.0-scsi-0:0:0:0
> >>
> >> the path_id is about disk or about disk slot ?
> >
> > Neither: it's pci function and scsi host:channel:target:lun
> >
> > As far as I can tell, path_id returns are completely useless for
> > labelling disks (since host and sometimes target are scan order
> > dependent).
> >
> > James
> >
> >
>=20
> I know the host:channel:target:lun but not deeply. the "lun" is about=
 a
> disk, or a disk slot?
> I mean,if I take the disk on a slot and plug in a new disk,will the
> ID_PATH change,or not ?
>=20
> many thanks.
>=20
[Jack Wang] It depends on driver implement. Driver base on
scsi_transport_sas(like mpt2sas pm8001 isci..)the number always get big=
ger,
but some driver bind the lun number with topology like phy number.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
