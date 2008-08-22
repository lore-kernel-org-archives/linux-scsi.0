From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Ksummit-2008-discuss] Kernel Summit Request for	Discussion:
 The Future of Target mode and Cloud storage on Linux
Date: Fri, 22 Aug 2008 23:00:25 +0400
Message-ID: <48AF0CC9.6060904@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu> <1219362832.3265.59.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-04.mailcluster.net ([77.221.130.216]:56983 "EHLO
	mail-relay-02.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752213AbYHVTAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2008 15:00:10 -0400
In-Reply-To: <1219362832.3265.59.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, ksummit-2008-discuss@lists.linux-foundation.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>

James Bottomley wrote:
> On Thu, 2008-08-21 at 18:31 -0500, Mike Christie wrote:
>> I think James also said something about moving STGT in-kernel to get 
>> performance gains, but I do not think it means that we have to push 
>> exact code that sits in Tomo's git tree from usrspace into the kernel. 
>> If along the way we replace it with scst or Nick's code and we end up 
>> with a variant of scst or Nicks code that can still support userspace 
>> targets then I do not think any one is going to make long threads like 
>> these have resulted in :)
> 
> I meant actually allowing performance critical pieces to work either
> in-user or in-kernel.  How, I'm not sure ... if we could use the same
> code for both, that would be brilliant ... if we have to have separate
> pieces, that will be OK.
> 
> The error injection and transport debug people think it's important to
> have the state machine in user space for fast prototyping and debugging,
> so I'm not going to take this away from them.

Nobody has been asking you about that. Simply, there's no need in it.

>> Will this work for everyone?
> 
> Sounds like a plan.  (However, it also sounds suspiciously like the last
> plan we had from the storage summit which didn't actually attract any
> implementers ...)

I at that time heard nothing about it. Nobody asked me, nobody let me 
know about it and nobody asked me to participate. Nothing about it was 
in linux-scsi. It was completely behind my back.

Vlad
