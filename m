From: Meelis Roos <mroos@linux.ee>
Subject: qla2xxx: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041)
Date: Sat, 19 Aug 2017 23:41:00 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1708192337130.26479@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44315 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751687AbdHSUlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 19 Aug 2017 16:41:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, qla2xxx-upstream@qlogic.com

Hello, I just tried Linux with the latest kernel (4.13-rc5+git) on a HP 
DL360 G6 with HP branded ISP2432 HBA. The driver mentions unsupported 
model of the card:

[    3.868589] scsi host1: qla2xxx
[    3.871696] qla2xxx [0000:07:00.0]-00fb:1: QLogic HPAE312A - PCI-Express Dual Port 4Gb Fibre Channel HBA.
[    3.871782] qla2xxx [0000:07:00.0]-00fc:1: ISP2432: PCIe (2.5GT/s x4) @ 0000:07:00.0 hdma+ host#=1 fw=8.03.00 (9496).
[    3.871973] qla2xxx [0000:07:00.1]-001d: : Found an ISP2432 irq 49 iobase 0xffffc900062c5000.
[    3.872568] qla2xxx [0000:07:00.1]-0034:4: MSI-X: Unsupported ISP 2432 SSVID/SSDID (0x103C,0x7041).

Is there some information I can provide to include this card in fully 
supported list?

-- 
Meelis Roos (mroos@linux.ee)
