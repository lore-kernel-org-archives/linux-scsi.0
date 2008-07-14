From: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: adaptec 3405 + 4 sas disks: synchronize_callback: synchronize failed, status = 226
Date: Mon, 14 Jul 2008 08:09:19 +0200
Message-ID: <200807140809.19937.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:51170 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYGNGYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 02:24:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: aacraid@adaptec.com


Hello,

I'm running 2.6.24.3 kernel and I'm getting few error messages comming =
from=20
aacraid driver. Hardware is adaptec 3405 running firmware 15728 + 4 SAS=
 300GB=20
harddisks configured in single raid10 array.

[167674.161866] synchronize_callback: synchronize failed, status =3D 22=
6
[168977.738031] synchronize_callback: synchronize failed, status =3D 22=
6
[172180.752140] synchronize_callback: synchronize failed, status =3D 22=
6
[177494.855145] synchronize_callback: synchronize failed, status =3D 22=
6
[189594.477223] synchronize_callback: synchronize failed, status =3D 22=
6
[191411.881236] synchronize_callback: synchronize failed, status =3D 22=
6
[217130.596663] synchronize_callback: synchronize failed, status =3D 22=
6
[219236.032362] synchronize_callback: synchronize failed, status =3D 22=
6

What does 226 mean and what does it indicate (serious problem?) ?

ps. would be good if prefix was added to these messages to know where t=
hese=20
come from
--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
