From: Roland Dreier <rdreier@cisco.com>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 13:43:59 -0800
Message-ID: <adapry5ykps.fsf@cisco.com>
References: <1195450523.7022.37.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:60708 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXKSVoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 16:44:08 -0500
In-Reply-To: <1195450523.7022.37.camel@pasglop> (Benjamin Herrenschmidt's message of "Mon, 19 Nov 2007 16:35:23 +1100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: benh@kernel.crashing.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>

 > I've been debugging various issues on the PowerPC 44x embedded
 > architecture which happens to have non-coherent PCI DMA.
 > 
 > One of the problem I'm hitting is that one really need to enforce
 > kmalloc alignement to cache lines or bad things will happen (among
 > others with USB), for some reasons, powerpc failed to do so, I fixed it.

Heh... I hit the same problem literally 5 years ago:
    http://lwn.net/Articles/1783/

I implemented the __dma_buffer annotation:
    http://lwn.net/Articles/2269/

But DaveM said we should just use the PCI pool code instead:
    http://lwn.net/Articles/2270/

 - R.
