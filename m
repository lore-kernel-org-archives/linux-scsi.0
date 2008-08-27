From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Summit Request for Discussion: The Future of Target mode
 and Cloud storage on Linux
Date: Wed, 27 Aug 2008 21:49:01 +0400
Message-ID: <48B5938D.8010400@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>	 <1219362832.3265.59.camel@localhost.localdomain>	 <48AF0CC9.6060904@vlnb.net> <1219432401.3339.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:50384 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750746AbYH0Rsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 13:48:35 -0400
In-Reply-To: <1219432401.3339.79.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>

James Bottomley wrote:
> On Fri, 2008-08-22 at 23:00 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley wrote:
>>> On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
>>>> I think James also said something about moving STGT in-kernel to get 
>>>> performance gains, but I do not think it means that we have to push 
>>>> exact code that sits in Tomo's git tree from usrspace into the kernel. 
>>>> If along the way we replace it with scst or Nick's code and we end up 
>>>> with a variant of scst or Nicks code that can still support userspace 
>>>> targets then I do not think any one is going to make long threads like 
>>>> these have resulted in :)
>>> I meant actually allowing performance critical pieces to work either
>>> in-user or in-kernel.  How, I'm not sure ... if we could use the same
>>> code for both, that would be brilliant ... if we have to have separate
>>> pieces, that will be OK.
>>>
>>> The error injection and transport debug people think it's important to
>>> have the state machine in user space for fast prototyping and debugging,
>>> so I'm not going to take this away from them.
>> Nobody has been asking you about that. Simply, there's no need in it.
> 
> I wasn't aware you were privy to my conversations ... however, I suggest
> that you must have missed it.
> 
> Quite a few people who want to work on transports don't have the budget
> for the hardware.  Emulators are things they use to get around this
> problem.  To them, therefore, it's a definite need.

Seems, there is a confusion and we are writing about different things. I 
mean backstorage device emulation in user space (this is what scst_user 
provides), but seems you mean the opposite side of SCSI commands 
processing in target: target transports, i.e. target drivers, in user 
space, which emulate some SCSI transport, correct?

>>>> Will this work for everyone?
>>> Sounds like a plan.  (However, it also sounds suspiciously like the last
>>> plan we had from the storage summit which didn't actually attract any
>>> implementers ...)
>> I at that time heard nothing about it. Nobody asked me, nobody let me 
>> know about it and nobody asked me to participate. Nothing about it was 
>> in linux-scsi. It was completely behind my back.
> 
> http://www.usenix.org/events/lsf08/
> 
> summaries page 6.
> 
> The invitation to participate was here:
> 
> http://marc.info/?t=119325401900042

I was aware about the event, although for obvious reasons wasn't able to 
participate. I meant not it, but the decision and the plan. Neither one 
of them was published in any public place, wasn't it?

> James
> 
> 
> 

