From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [ANNOUNCE 0/2] Serial Attached SCSI (SAS) support for the Linux
 kernel
Date: Mon, 12 Sep 2005 17:35:04 -0400
Message-ID: <4325F488.5040304@adaptec.com>
References: <4321E2C1.7080507@adaptec.com> <20050911092030.GA5140@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:46491 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932268AbVILVfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 17:35:11 -0400
In-Reply-To: <20050911092030.GA5140@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 09/11/05 05:20, Christoph Hellwig wrote:
> Thanks for finally posting your code.
> 
> At the core it's some really nice code dealing with host-based SAS
> implementations.

Thank you Christoph.  Much appreciated.

> What's not nice is that it's not intgerating with the
> SAS transport class I posted,

I wish there was something I could do.  HP and LSI
were aware of my efforts since the beginning of the year.

As well, you had a copy of my code July 14 this year,
long before starting your work on your SAS class for LSI and
HP (so its acceptance is guaranteed), after OLS.

We did meet at OLS and we did have the SAS BOF.  I'm not sure
why you didn't want to work together?

> it's duplicating things like LUN disocvery

This is a much more involved subject than meets the eye.

> from the SCSI core code, and adding it's own sysfs representation that's
> very different from the way the SCSI core and transport classes do it.

Yes, it is time to evolve.

I've pointed out many times the shortcomings of expanding the
JB's "transport _attribute_ class" into a "transport layer" in
recent threads.

I'm sorry but over everything else, we need a common base,
(what you call "techno-gibberish") in order to see eye to eye.

> Are you willing to work with us to intgerate it with the infrastructure
> we have?

I'm sure you've already taken a closer look at the SAS code 
I posted.   Study it, read the spec, read the code again.

Let me know if I can help with anything.

Overall, MPT is very different in design than a disclosed
transport.  Talk to HP, LSI and Dell and see what they think.

	Luben

