From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: aacraid and rotational 1 even for ssd disks
Date: Sat, 7 Nov 2015 15:00:35 +0100
Message-ID: <201511071500.35885.a.miskiewicz@gmail.com>
Reply-To: arekm@maven.pl
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34488 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbbKGOAj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Nov 2015 09:00:39 -0500
Received: by lfgh9 with SMTP id h9so82703380lfg.1
        for <linux-scsi@vger.kernel.org>; Sat, 07 Nov 2015 06:00:37 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com


Hi.

I wonder if aacraid shouldn't properly inform kernel about sdd disk via=
=20
/sys/devices/../queue/rotational flag?

Using 3.18.22 kernel and aacraid driver tells linux that all drives are=
=20
rotational:

raid:
# cat=20
/sys/devices/pci0000:80/0000:80:03.0/0000:81:00.0/host10/target10:0:0/1=
0:0:0:0/block/sda/queue/rotational
1

lvm on top of that raid:
# cat /sys/devices/virtual/block/dm-*/queue/rotational
1
1
1

while this system has raid array of SSD drives only (INTEL SSDSC2BB30).=
 No=20
rotational disks.

Adaptec ASR8405 7.8-0 (32730) firmware.

--=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / ( maven.pl | pld-linux.org )
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
