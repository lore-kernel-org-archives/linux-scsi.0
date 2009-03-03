From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 00:48:34 +0100
Message-ID: <20090303234834.GA13389@elte.hu>
References: <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain> <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr> <1236097526.3263.17.camel@localhost.localdomain> <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:46145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754714AbZCCXsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Mar 2009 18:48:51 -0500
Content-Disposition: inline
In-Reply-To: <49ADBE29.4040706@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
> > i picked up a v1 patch from the SCSI list that 
> > i reported and which patch was sent to me. I did that in the 
> > hope to fix a serious lockup bug that is still unfixed in the
> > upstream kernel
> 
> Perhaps you could avoid putting such fixes into published 
> merge branches.

Yeah, these commits are in none of the topic branches that are 
the git base of development, they are all already in a separate 
branch named "tip:out-of-tree". That separate branch carries 
assorted fixlets for various bugs we trigger in -tip qa. It 
never goes upstream-wards, obviously. It's a bit like the 
fixlets portion of -mm.

	Ingo
