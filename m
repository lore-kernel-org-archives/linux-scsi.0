From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: 2.6.9 aacraid
Date: Tue, 9 Nov 2004 21:56:59 +0100
Message-ID: <20041109205659.GI1309@mail.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hell.sks3.muni.cz ([147.251.210.30]:29397 "EHLO
	hell.sks3.muni.cz") by vger.kernel.org with ESMTP id S261677AbUKIU5F
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Nov 2004 15:57:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

Hello,

as I have 2.6.9 kernel and ASR 2200S controller (now without hang probl=
ems)

I can see this on totaly unloaded server (load 0.0 0.0 0.1)

undomiel:~# dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1024
1024+0 records in
1024+0 records out
1073741824 bytes transferred in 24.339853 seconds (44114557 bytes/sec)
undomiel:~# dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1024
1024+0 records in
1024+0 records out
1073741824 bytes transferred in 26.839943 seconds (40005369 bytes/sec)

I have 8x 73GB SCSI disks (4 per channel) set up into hardware RAID 5 a=
rray.

Should not I see more performance?

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
