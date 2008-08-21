From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for Discussion:
	The Future of Target mode and Cloud storage on Linux
Date: Thu, 21 Aug 2008 18:53:52 -0500
Message-ID: <1219362832.3265.59.camel@localhost.localdomain>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58144 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbYHUXx4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2008 19:53:56 -0400
In-Reply-To: <48ADFAB7.5010201@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, ksummit-2008-discuss@lists.linux-foundation.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>

On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
> I think James also said something about moving STGT in-kernel to get 
> performance gains, but I do not think it means that we have to push 
> exact code that sits in Tomo's git tree from usrspace into the kernel. 
> If along the way we replace it with scst or Nick's code and we end up 
> with a variant of scst or Nicks code that can still support userspace 
> targets then I do not think any one is going to make long threads like 
> these have resulted in :)

I meant actually allowing performance critical pieces to work either
in-user or in-kernel.  How, I'm not sure ... if we could use the same
code for both, that would be brilliant ... if we have to have separate
pieces, that will be OK.

The error injection and transport debug people think it's important to
have the state machine in user space for fast prototyping and debugging,
so I'm not going to take this away from them.

> Will this work for everyone?

Sounds like a plan.  (However, it also sounds suspiciously like the last
plan we had from the storage summit which didn't actually attract any
implementers ...)

James


