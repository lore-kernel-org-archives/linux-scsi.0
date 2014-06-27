From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: help decoding aacraid errors (3.10.40 kernel)
Date: Fri, 27 Jun 2014 10:55:08 +0200
Message-ID: <201406271055.08750.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:40257 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaF0IzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jun 2014 04:55:12 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so4911168wes.18
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2014 01:55:11 -0700 (PDT)
Received: from t400.localnet ([91.234.176.246])
        by mx.google.com with ESMTPSA id k19sm75498573wie.20.2014.06.27.01.55.09
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 27 Jun 2014 01:55:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hello.

I'm using 3.10.40 kernel with adaptec 3405 and unfortunately I'm gettin=
g I/O=20
errors and dmesg errors like below. Is there a howto how to decode thes=
e=20
errors or what these actually mean?

Some details, including full dmesg output at
http://ixion.pld-linux.org/~arekm/p2/web3-adaptec-problem/
eg
http://ixion.pld-linux.org/~arekm/p2/web3-adaptec-problem/dmesg.txt

That doesn't seem to be hard disk error (at least I don't see any bad e=
rrors=20
from arcconf tool).

[3757350.671843] sd 0:0:2:0: [sdc] CDB:=20
[3757350.671844] cdb[0]=3D0x28: 28 00 00 a0 2c a8 00 00 08 00
[3757350.671856] sd 0:0:2:0: [sdc] Unhandled sense code
[3757350.671858] sd 0:0:2:0: [sdc] =20
[3757350.671860] Result: hostbyte=3D0x00 driverbyte=3D0x08
[3757350.671862] sd 0:0:2:0: [sdc] =20
[3757350.671863] Sense Key : 0x4 [current]=20
[3757350.671866] sd 0:0:2:0: [sdc] =20
[3757350.671868] ASC=3D0x44 ASCQ=3D0x0
[3757350.671870] sd 0:0:2:0: [sdc] CDB:=20
[3757350.671872] cdb[0]=3D0x28: 28 00 00 a0 2c b0 00 00 08 00
[3757350.671884] sd 0:0:2:0: [sdc] Unhandled sense code
[3757350.671886] sd 0:0:2:0: [sdc] =20
[3757350.671888] Result: hostbyte=3D0x00 driverbyte=3D0x08
[3757350.671890] sd 0:0:2:0: [sdc] =20
[3757350.671892] Sense Key : 0x4 [current]=20
[3757350.671894] sd 0:0:2:0: [sdc] =20
[3757350.671896] ASC=3D0x44 ASCQ=3D0x0
[3757350.671899] sd 0:0:2:0: [sdc] CDB:=20
[3757350.671900] cdb[0]=3D0x28: 28 00 00 a0 2c b8 00 00 08 00
[3757350.671912] sd 0:0:2:0: [sdc] Unhandled sense code
[3757350.671914] sd 0:0:2:0: [sdc] =20
[3757350.671916] Result: hostbyte=3D0x00 driverbyte=3D0x08
[3757350.671918] sd 0:0:2:0: [sdc] =20
[3757350.671920] Sense Key : 0x4 [current]=20
[3757350.671923] sd 0:0:2:0: [sdc] =20
[3757350.671924] ASC=3D0x44 ASCQ=3D0x0
[3757350.671927] sd 0:0:2:0: [sdc] CDB:=20
[3757350.671928] cdb[0]=3D0x28: 28 00 00 a0 2c c0 00 00 08 00
[3757350.671939] sd 0:0:2:0: [sdc] Unhandled sense code
[3757350.671941] sd 0:0:2:0: [sdc] =20
[3757350.671943] Result: hostbyte=3D0x00 driverbyte=3D0x08
[3757350.671945] sd 0:0:2:0: [sdc] =20
[3757350.671947] Sense Key : 0x4 [current]=20
[3757350.671950] sd 0:0:2:0: [sdc] =20
[3757350.671951] ASC=3D0x44 ASCQ=3D0x0
[3757350.671954] sd 0:0:2:0: [sdc] CDB:=20
[3757350.671955] cdb[0]=3D0x28: 28 00 00 a0 2c c8 00 00 08 00


--=20
Arkadiusz Mi=C5=9Bkiewicz, arekm / maven.pl

Q: vger.kernel.org postmasters - always rude and impolite, hmm?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
