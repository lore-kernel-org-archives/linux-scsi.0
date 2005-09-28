From: "erich" <erich@areca.com.tw>
Subject: ARECA 'arcmsr' new Linux SCSI RAID driver version 1.20.00.11
Date: Wed, 28 Sep 2005 14:57:15 +0800
Message-ID: <000b01c5c3f9$dda04b70$9300a8c0@erich2003>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="big5";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 220-130-178-143.HINET-IP.hinet.net ([220.130.178.143]:30699
	"EHLO areca.com.tw") by vger.kernel.org with ESMTP id S1751168AbVI1G6u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2005 02:58:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Linux Matt Dainty <matt@bodgit-n-scarper.com>, Linux Kornel Wieliczek <e0815w@onlinehome.de>, Linux James Bottomley <James.Bottomley@SteelEye.com>, Linux Christoph Hellwig <hch@infradead.org>, Linux Arjan van de Ven <arjan@infradead.org>, Linux Adrian Bunk <bunk@stusta.de>

Hi Dear all,

I  had modified some incorrect code about Arjan van de Ven comment.
And change this driver version to 1.20.00.11 .

     1.20.00.10    9/23/2005         enhance sysfs function for change 
driver's max tag Q number.
                                                   add DMA_64BIT_MASK for 
backward compatible with all 2.6.x
                                                   add some useful message 
for abort command
                                                   add ioctl code 
'ARCMSR_IOCTL_FLUSH_ADAPTER_CACHE'
                                                   customer can send this 
command for sync raid volume data

     1.20.00.11    9/29/2005         by comment of Arjan van de Ven fix 
incorrect msleep redefine
                                                   cast off 
sizeof(dma_addr_t) condition for 64bit pci_set_dma_mask

Best Regards
Erich Chen 

