From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: missing mptsas support for  LSI Logic / Symbios Logic SAS1068 PCI-X Fusion-MPT SAS [1000:0055] (rev 02)
Date: Fri, 19 Nov 2010 18:42:25 +0100
Message-ID: <201011191842.25939.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62424 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab0KSRm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Nov 2010 12:42:29 -0500
Received: by eye27 with SMTP id 27so2866580eye.19
        for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2010 09:42:28 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org


Hi,

I wonder if mptsas driver is able to support this hardware?

04:08.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS10=
68 PCI-
X Fusion-MPT SAS [1000:0055] (rev 02)
        Subsystem: Intel Corporation Device [8086:3504]

Currently driver doesn't handle 1000:0055 pciid. The problem seems quit=
e old=20
since I found someone asking for it long time ago=20
http://lkml.org/lkml/2007/1/23/87

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
