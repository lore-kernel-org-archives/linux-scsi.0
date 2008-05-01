From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] Use of new scsi_allocate_command
Date: Thu, 01 May 2008 18:36:17 +0300
Message-ID: <4819E371.2040403@panasas.com>
References: <4819C9DB.60104@panasas.com>	 <1209651854.3067.8.camel@localhost.localdomain>	 <4819DA39.70505@panasas.com> <1209655360.3067.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:60233 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952AbYEAPiL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 11:38:11 -0400
In-Reply-To: <1209655360.3067.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>

On Thu, May 01 2008 at 18:22 +0300, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Thu, 2008-05-01 at 17:56 +0300, Boaz Harrosh wrote:
>> The call to pci_map_page() on an ISA case will it not bounce the
>> buffer?
> 
> Only if the system isn't a PCI_DMA_BUS_IS_PHYS one.
> 
> That means basically either has an iommu/gart or has some silly swiotlb
> to emulate one.
> 
> That means for standard x86 isa systems the answer is no: the buffer has
> to be allocated within the isa region because pci_map is simply a
> virt_to_phys.
> 
> James
> 
OK Thanks, so the second patch then. That will solve it.

Boaz

