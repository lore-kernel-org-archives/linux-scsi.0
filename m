From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: hwo to adjust interrupt?
Date: Fri, 12 Aug 2005 13:45:26 -0400
Message-ID: <1123868726.5546.89.camel@localhost.localdomain>
References: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from leviathan.ele.uri.edu ([131.128.51.64]:20172 "EHLO
	leviathan.ele.uri.edu") by vger.kernel.org with ESMTP
	id S1750757AbVHLRpk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2005 13:45:40 -0400
In-Reply-To: <OF33C7B841.0ED0EFDF-ON8825705B.00600DDB-8825705B.0060A40B@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2005-08-12 at 10:35 -0700, Bryan Henderson wrote:
> >>How much extra work does Linux have to do for each interrupt?
> >
> >usually 1 pci mmio read; the rest is negligible.
> 
> I was hoping you would cater better to my ignorance of how PCI interrupt 
> handling works in Linux.
> 
> Is it the case that Linux invokes the registered interrupt handler of each 
> of the drivers for the devices that share the interrupt, and each does an 
> mmio read of its device to find out if it had reason to generate an 
> interrupt?  So the waste is that extra call, and you're saying the CPU 
> instructions involved are negligible compared to the mmio read?
> 
> Are these level-sensitive interrupts, so that if both devices need service 
> at the same time, they generate just one interrupt and neither device 
> driver call is wasted?
> 

i guess so. 

also sound like the intr overhead is not that big as i assumed.
 
so if i really want to make myself comfortable, i can disable the share
interrupt when register interrupt in driver code, rite?

ming


