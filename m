From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Wed, 06 Oct 2004 17:48:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41646848.6080108@adaptec.com>
References: <OF4B71AD6D.2ACA3A91-ONC1256F25.00518CAF-C1256F25.005B33E2@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:35532 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S269524AbUJFVtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 17:49:07 -0400
In-Reply-To: <OF4B71AD6D.2ACA3A91-ONC1256F25.00518CAF-C1256F25.005B33E2@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Martin Peschke3 wrote:
> 
> 
> 
> 
>  > That is right, 64 bit LUNs were mandated in SAM-2
>  > (standardized in 2003) and SAM-3 (soon to become a standard).
> 
> So, do you know how to read table A.2? (Yes, it's only "informative",
> and therewith not normative)
> 
>  > When SCSI devices start using advanced LUN features like
>  > "well known logical units" (SPC-3 rev 21 section 8)
>  > we are really going to start hurting.
> 
> I see. The bone of contention from my perspective has been that LLDDs
> are currently required to guess in which way the mid-layer has compressed
> a LUN, and the resulting question: "Which LUN addressing modes does
> your LLDD support?" Ouch!

I remember we talked about 64 bit LUNs 2 years ago on linux-scsi.

I think the LUN (structure) should be opaque to SCSI Core.
So in effect, user applications and LLDDs would interpret it,
but SCSI Core would simply pass it back and forth.

	Luben



