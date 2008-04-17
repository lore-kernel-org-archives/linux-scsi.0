From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Query regarding modifying the DMA Mask based on the available memory in the system
Date: Thu, 17 Apr 2008 16:44:37 +0200
Message-ID: <87iqygk0bu.fsf@basil.nowhere.org>
References: <5AE055B67BB5764693E2900C7E3699BE010CAB76@pamail.ad.lsil.com>
	<1208441932.3150.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:64205 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbYDQPAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2008 11:00:54 -0400
In-Reply-To: <1208441932.3150.4.camel@localhost.localdomain> (James Bottomley's message of "Thu, 17 Apr 2008 09:18:52 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Prakash, Sathya" <Sathya.Prakash@lsi.com>, linux-scsi@vger.kernel.org

>
> For drivers that can alter their descriptor types, we have this
> function:
>
> dma_get_required_mask()

Are you sure we have it? It seems to be in drivers/base/platform.c
conditional on ARCH_HAS_DMA_GET_REQUIRED_MASK, but according to my
grep no architecture ever sets that flag.

I don't think it would be very hard to implement on x86 at least,
mind you. Just nobody seems to have done it so far.

-Andi

