From: Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Subject: cp from SATA to SCSI freeze
Date: Sun, 24 Oct 2004 12:13:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098612795.11032.20.camel@tycho.astronomy.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fitch1.uni2.net ([130.227.52.104]:63438 "EHLO fitch1.uni2.net")
	by vger.kernel.org with ESMTP id S261427AbUJXKNV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Oct 2004 06:13:21 -0400
Received: from [192.168.1.102] (83.72.33.52.ip.tele2adsl.dk [83.72.33.52])
	by fitch1.uni2.net (8.12.6/8.11.6) with ESMTP id i9OADE3J019753
	for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2004 12:13:14 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

When I copy a directory containing about 6Gb of files
from a SATA disk to my SCSI system disk the system freezes
so I have to press the reset button. This happens with
cp -r, but is does not happen with mv. cp -r works fine
from the SCSI to the SATA disk. The problem reproduces
every time I try to cp from SATA to SCSI.

Is this a known issue?

OS: Mandrake 2.6.8.1-12.5mdksmp x86_64 2 AMD Opteron(tm) Processors
MB: Tyan S2885 Thunder K8W
SCSI IF: Adaptec 29160
Advanced Micro Devices|AMD-8131 PCI-X
Advanced Micro Devices|K8 [Athlon64/Opteron]
sata_sil: Silicon Image|Sil3114A Serial ATA
aic7xxx : Adaptec|7892A

Is there something that I can to to locate the
problem?

 -- Bjarne

-- 
Bjarne Thomsen <bjarne.thomsen@get2net.dk>
Institute of Physics & Astronomy

