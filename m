From: Lukas Hejtmanek <xhejtman@mail.muni.cz>
Subject: 2.6.9 aacraid hangup
Date: Fri, 22 Oct 2004 01:32:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041021233238.GB11607@mail.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hell.sks3.muni.cz ([147.251.210.30]:19335 "EHLO
	hell.sks3.muni.cz") by vger.kernel.org with ESMTP id S271095AbUJUXcn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 19:32:43 -0400
Received: from xhejtman by hell.sks3.muni.cz with local (Exim 3.36 #1 (Debian))
	id 1CKmQA-00032g-00
	for <linux-scsi@vger.kernel.org>; Fri, 22 Oct 2004 01:32:38 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I'm using vanilla kernel 2.6.9 and ASR 2200S card with firmware 6011.

I have 1 P4 Xeon (HT enabled) and SMP configured kernel with 1GB of RAM=
=2E

8 SCSI HDD is connected to this card in HW RAID 5 array.

If I do:

dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1204 &
dd if=3D/dev/sda of=3D/dev/null bs=3D1M count=3D1024 skip=3D2000

then with VERY high probability system hangs. It responds that disks we=
nt
offline and no more i/o operation successes.

I have 2 partitions there. Witch EXT3 filesystem and with XFS filesyste=
m.

Is there something I could do?=20

(please cc me as I'm not in the list)

--=20
Luk=E1=B9 Hejtm=E1nek
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
