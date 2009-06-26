From: Amit Kumar Sharma <amitsharma.9@samsung.com>
Subject: ATA vs SCSI interface
Date: Fri, 26 Jun 2009 08:26:15 +0530
Message-ID: <874A78DF4E46449393EE406F0D13C043@sisodomain.com>
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:59103 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbZFZCzw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 22:55:52 -0400
Received: from epmmp1 (mailout3.samsung.com [203.254.224.33])
 by mailout1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KLT005WZS51PB@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jun 2009 11:55:49 +0900 (KST)
Received: from amitksharma ([107.108.214.35])
 by mmp1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0KLT00LBDS505D@mmp1.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jun 2009 11:55:49 +0900 (KST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi Guys,

I am new to storage , I need clarification between 
sg0--1(scsi) and sda-- b(ATA)

I want to implement microcode for firmware download.Which 
interface is correct for SSD ATA or SCSI.

In my opinion if I will use Scsi interface sg_ioctl , I can 
download firmware and my code will be independent to kernel 
version.But if I use ATA_ioctl, I have to made changes for 
adding support of microcode in ATA_ioctl because From the 
code it looks like it will not support DMA_TO_DEVICE.

Please provide inputs to clarify understanding.

Thanks
Amit 


