From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: 64bit DMA testing
Date: Wed, 29 Oct 2003 16:30:46 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9FCF16.1020805@il.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop3.galileo.co.il ([199.203.130.130]:11940 "EHLO
	mail.galileo.co.il") by vger.kernel.org with ESMTP id S261807AbTJ2Pbw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 10:31:52 -0500
Received: from il.marvell.com (linux2.galileo.co.il [10.2.40.2])
	by mail.galileo.co.il (8.12.6/8.12.6) with ESMTP id h9TFVWGn015963
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2003 17:31:32 +0200 (IST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi All,

Is there any utility that produces SCSI commands with 64bit DMA buffers 
(scatter-gather or single buffer).

The machine I'm currently using is dual XEON on 6GByte DRAM with PAE 
enabled and RedHat 9 kernel compiled as SMP bigmem kernel (2.4.20)
I have also Suse linux 64bit on dual Opteron AMD ; does this make life 
easier for generating 64bit DMA buffers ?

Thank you,
Rabeeh


