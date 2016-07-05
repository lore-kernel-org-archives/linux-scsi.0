From: Meelis Roos <mroos@linux.ee>
Subject: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041)
Date: Wed, 6 Jul 2016 00:09:41 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1607060007120.8418@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:48445 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588AbcGEVH4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Jul 2016 17:07:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org

I just got a HP Proliant DL360G6 with a PCI-E FC card from HP and got 
this warning during driver initialization:

[    4.166160] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driver: 8.07.00.33-k.
[    4.166633] qla2xxx [0000:07:00.0]-001d: : Found an ISP2432 irq 48 iobase 0xffffc900035d2000.
[    4.167084] qla2xxx [0000:07:00.0]-0034:3: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).

Why does the driver need to know subsystem ID-s at all?

-- 
Meelis Roos (mroos@linux.ee)
