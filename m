From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: queuecommand called in IRQ run level
Date: Sun, 24 Aug 2003 20:46:02 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F48F9DA.6080202@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:2010 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S261284AbTHXRoD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Aug 2003 13:44:03 -0400
Received: from il.marvell.com (linux2.galileo.co.il [10.2.40.2])
	by mail.galileo.co.il (8.12.6/8.12.6) with ESMTP id h7OIfG6D000013
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2003 20:41:16 +0200 (GMT-2)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

Is it possible that queuecommand be called in ISR time ? (IRQ run level)
I want to do kmalloc with GFP_KERNEL priority in queuecommand (or 
actually pci_pool_alloc which eventually will call kmalloc in pool 
getting low in memory).

Thank you,
Rabeeh


