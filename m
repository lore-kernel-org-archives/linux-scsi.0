From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] add device_configure to the transport classes
Date: Wed, 6 Oct 2004 18:29:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF4B71AD6D.2ACA3A91-ONC1256F25.00518CAF-C1256F25.005B33E2@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:61386 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S269419AbUJFQad
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Oct 2004 12:30:33 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>





> That is right, 64 bit LUNs were mandated in SAM-2
> (standardized in 2003) and SAM-3 (soon to become a standard).

So, do you know how to read table A.2? (Yes, it's only "informative",
and therewith not normative)

> When SCSI devices start using advanced LUN features like
> "well known logical units" (SPC-3 rev 21 section 8)
> we are really going to start hurting.

I see. The bone of contention from my perspective has been that LLDDs
are currently required to guess in which way the mid-layer has compressed
a LUN, and the resulting question: "Which LUN addressing modes does
your LLDD support?" Ouch!

Martin

