From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Query regarding modifying the DMA Mask based on the available
 memory in the system
Date: Thu, 17 Apr 2008 17:06:50 +0200
Message-ID: <4807678A.8020906@firstfloor.org>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>	 <1208441932.3150.4.camel@localhost.localdomain>	 <87iqygk0bu.fsf@basil.nowhere.org> <1208444622.3150.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:47039 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941AbYDQPGz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 11:06:55 -0400
In-Reply-To: <1208444622.3150.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-04-17 at 16:44 +0200, Andi Kleen wrote:
>>> For drivers that can alter their descriptor types, we have this
>>> function:
>>>
>>> dma_get_required_mask()
>> Are you sure we have it? It seems to be in drivers/base/platform.c
>> conditional on ARCH_HAS_DMA_GET_REQUIRED_MASK, but according to my
>> grep no architecture ever sets that flag.
> 
> Yes ... positive.  That's the default and correct implementation based
> on the largest addressable physical memory.

Ok but still the whole thing is completely useless right now.

>> I don't think it would be very hard to implement on x86 at least,
>> mind you. Just nobody seems to have done it so far.
> 
> Really, only machines with IOMMUs that want to restrict this need
> implement it. 

I don't think so. For once in the scenario described by the original
poster it makes some sense even without IOMMU.

-Andi
