From: "Martin Jimenez Diego" <dmartin@sopragroup.com>
Subject: scsi-backup errors with dell
Date: Mon, 20 Dec 2004 15:01:45 +0100
Message-ID: <53742A4D424C2645BFC5E98B2013B12B7FC22B@WEXCHBE01-VS.ptx.fr.sopra>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound1.z-ptx-11.fr.sopragroup.com ([81.80.239.198]:16267
	"EHLO outbound1.sopragroup.com") by vger.kernel.org with ESMTP
	id S261299AbULTODA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2004 09:03:00 -0500
Received: by outbound1.sopragroup.com (8.12.10/8.12.10/outbound-A02) with ESMTP id iBKE2sKx003968
          for <linux-scsi@vger.kernel.org>; Mon, 20 Dec 2004 15:02:57 +0100
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hello.
we had PE2550 server with RH7.1. it has a PERC3/DC card atached to a Po=
wervault 220s and to a Powervault 110t dlt, each device in each separat=
e cable.
the disk cabin had 3 disks and reciently we added three disks more. we =
made the new logical volume (raid5) with no problem, and the new partit=
ion is working ok. BUT since then our dlt is experiencing problems.
when we launch backups they don=B4t work, and in 'messages' we get the =
following error:

Dec 14 06:31:16 bond2 kernel: st0: Error 250400fb (sugg. bt 0x20, drive=
r bt 0x5, host bt 0x4).
Dec 14 06:31:24 bond2 kernel: st0: Error with sense data: [valid=3D0] I=
nfo fld=3D0x0, Current st09:00: sense key Unit Attention
Dec 14 06:31:24 bond2 kernel: Additional sense indicates Power on,reset=
,or bus device reset

the firmware version of PERC is 161J, BIOS version 3.17, driver version=
 1.14g

any help would be ver y very appreciated

no backup in xmas is no good  :-(

diego martin
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
