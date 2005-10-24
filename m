From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Mon, 24 Oct 2005 09:51:06 -0400
Message-ID: <435CE6CA.4070704@adaptec.com>
References: <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com> <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com> <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com> <43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de> <20051022105815.GB3027@infradead.org> <1129994910.6286.21.camel@sipan.sipan.org> <20051022171943.GA7546@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:27063 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750956AbVJXNvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 09:51:18 -0400
In-Reply-To: <20051022171943.GA7546@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sergey Panov <sipan@sipan.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

On 10/22/05 13:19, Christoph Hellwig wrote:
> On Sat, Oct 22, 2005 at 11:28:30AM -0400, Sergey Panov wrote:
> 
>> It is a mistake to think that you can not do a big rework and keep SCSI
>>sub-system stable. You just have to make sure the OLD way is supported
>>for as log as it is needed.
> 
> 
> No.  Rewriting something from scratch is horrible engineering practice.

Off Topic:
	Discourse on Christoph's "Rewriting something from scratch
		is horrible engineering practice"

Christoph,

Imagine a for ( ) { } loop spanning 5000 lines.  Imagine never using
functions to separate things.  But imagine that a _factory_ is using
this code on its production line and that code, although badly written,
does work and keeps the production line going and thousands of
people working.

They hire an engineer to make it _managable_ and supportable -- this
warrants understanding the production line, what the code does, what it
controls and how.  Understanding how the factory workers use it and what
they expect.  Understanding the code (which may not be as easy).  Then it
is rewritten so that it can be easily supported and maintained.

This is real life example.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
