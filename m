From: Yuri Prushinsky <prushinsky@hotbox.ru>
Subject: ide-scsi emulation hangs the kernel?
Date: Wed, 10 Dec 2003 01:36:44 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1487717917.20031210013644@hotbox.ru>
Reply-To: Yuri Prushinsky <prushinsky@hotbox.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.hotbox.ru ([80.68.244.50]:53253 "EHLO smtp.hotbox.ru")
	by vger.kernel.org with ESMTP id S262098AbTLIWhy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2003 17:37:54 -0500
Received: from computer.thko.com ([217.74.138.51])
	(authenticated bits=0)
	by smtp.hotbox.ru (8.12.9/8.12.9) with ESMTP id hB9Ma8V6038540
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2003 01:36:09 +0300 (MSK)
	(envelope-from prushinsky@hotbox.ru)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hey all! Could anybody please tell me what's wrong with the ide-scsi
emulation in 2.4.21? I have a cd-rw drive as a hdd, it works fine but
the system (redhat9) suddenly freezes at any time with the following
messages:


Dec  8 01:11:14 localhost kernel: scsi : aborting command due to timeout : pid 22251, scsi0, channel 0, id 0, lun 0 Request
Sense 00 00 00 40 00
Dec  8 01:11:14 localhost kernel: hdd: lost interrupt
Dec  8 01:11:14 localhost kernel: ide-scsi: CoD != 0 in idescsi_pc_intr
Dec  8 01:11:14 localhost kernel: hdd: DMA disabled
Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete
Dec  8 01:11:14 localhost kernel: hdd: irq timeout: status=0x80 { Busy }
Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete
Dec  8 01:11:14 localhost kernel: hdd: irq timeout: status=0x80 { Busy }
Dec  8 01:11:14 localhost kernel: hdd: ATAPI reset complete

  

-- 
Best regards,
 Yura                          mailto:prushinsky@hotbox.ru

