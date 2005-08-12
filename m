From: Bryan Henderson <hbryan@us.ibm.com>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 10:35:29 -0700
Message-ID: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
References: <1123866258.3218.29.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:64456 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750757AbVHLRfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 13:35:32 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j7CHZRmT023811
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 13:35:27 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7CHZRZv229210
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 13:35:27 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j7CHZQb8031598
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 13:35:27 -0400
In-Reply-To: <1123866258.3218.29.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mingz@ele.uri.edu

>>How much extra work does Linux have to do for each interrupt?
>
>usually 1 pci mmio read; the rest is negligible.

I was hoping you would cater better to my ignorance of how PCI interrupt 
handling works in Linux.

Is it the case that Linux invokes the registered interrupt handler of each 
of the drivers for the devices that share the interrupt, and each does an 
mmio read of its device to find out if it had reason to generate an 
interrupt?  So the waste is that extra call, and you're saying the CPU 
instructions involved are negligible compared to the mmio read?

Are these level-sensitive interrupts, so that if both devices need service 
at the same time, they generate just one interrupt and neither device 
driver call is wasted?

