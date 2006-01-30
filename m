From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: FW: MSI-X on 2.6.15
Date: Mon, 30 Jan 2006 10:33:50 -0600
Message-ID: <D4CFB69C345C394284E4B78B876C1CF10B8AC113@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas04.cce.hp.com ([161.114.21.107]:32410 "EHLO
	ccerelbas04.cce.hp.com") by vger.kernel.org with ESMTP
	id S932369AbWA3Qdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2006 11:33:55 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Mark Maule <maule@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>

Greg KH,
We have the same results on 2.6.15, the MSI-X table is all zeroes. See
below. Any ideas of what to do do next? The driver works on x86_64. Is
there any thing extra I need to do on ia64?

Andrew, can you try 2.6.16-rc1 and/or the rc1-git4 kernels?

Thanks,
mikem

> -----Original Message-----
> From: Patterson, Andrew D (Linux R&D) 
> Sent: Friday, January 27, 2006 6:13 PM
> To: Miller, Mike (OS Dev)
> Subject: MSI-X on 2.6.15
> 
> Mike,
> 
> Here is what I get on 2.6.15.  I may look familiar.
> 
> Andrew
> 
> HP CISS Driver (v 2.6.8)
> GSI 45 (level, low) -> CPU 0 (0x0000) vector 52
> ACPI: PCI Interrupt 0000:46:01.0[A] -> GSI 45 (level, low) -> IRQ 52
> cciss: using DAC cycles
>       blocks= 143305920 block_size= 512
>       heads= 255, sectors= 32, cylinders= 17562
> 
>       blocks= 143305920 block_size= 512
>       heads= 255, sectors= 32, cylinders= 17562
> 
>       blocks= 71065440 block_size= 512
>       heads= 255, sectors= 32, cylinders= 8709
> 
>       blocks= 143305920 block_size= 512
>       heads= 255, sectors= 32, cylinders= 17562
> 
>  cciss/c0d0: p1 p2 p3
>       blocks= 143305920 block_size= 512
>       heads= 255, sectors= 32, cylinders= 17562
> 
>  cciss/c0d1: p1 p2 p3
>       blocks= 71065440 block_size= 512
>       heads= 255, sectors= 32, cylinders= 8709
> 
>  cciss/c0d2: p1 p2 p3
> GSI 63 (level, low) -> CPU 1 (0x0100) vector 53
> ACPI: PCI Interrupt 0000:4a:00.0[A] -> GSI 63 (level, low) -> IRQ 53
> cciss: offset = 0xfe000 table offset = 0xfe000 BIR = 0x0
> cciss: 0: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 1: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 2: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 3: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: using DAC cycles
> GSI 71 (level, low) -> CPU 2 (0x0200) vector 59
> ACPI: PCI Interrupt 0000:88:00.0[A] -> GSI 71 (level, low) -> IRQ 59
> cciss: offset = 0xfe000 table offset = 0xfe000 BIR = 0x0
> cciss: 0: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 1: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 2: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: 3: vector = 0,msg data = 0, msg upper addr = 0,msg addr = 0
> cciss: using DAC cycles
>       blocks= 143305920 block_size= 512
>       heads= 255, sectors= 32, cylinders= 17562
> 
> 
