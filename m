From: Matthew Schumacher <matt.s@aptalaska.net>
Subject: Re: new kernel = megaraid performance cut in half
Date: Thu, 16 May 2002 10:59:01 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3CE40175.20701@aptalaska.net>
References: <E178Pgv-0004l5-00@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aptalaska.net (ancnat1.apto.aptalaska.net [12.104.83.61])
	by larryboy.aptalaska.net (8.11.6/8.11.6) with ESMTP id g4GJ1mg00791
	for <linux-scsi@vger.kernel.org>; Thu, 16 May 2002 11:01:48 -0800 (AKDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Alan Cox wrote:
>>>I am running 7.3 (upgraded from 7.2) and I feel that the 2.4.18 kernel
>>>with the new VM code is actually inferior to that of 2.4.9-31. I have lots
>>>of memory (1.2 gig) and lots of disk access, and I see more swap and worse
>>>interactive performance on 2.4.18 (redhat supplied kernel) as compared to 
>>>the redhat supplied 2.4.9-31 for 7.2.
>>
>>Hmm, the reason why I upgraded to 2.4.18 in the first place was to fix a 
>>bunch of problems with quota.  I wonder if 2.4.9-31 will work with the 
>>quotas correctly, I was on 2.4.7.
> 
> 
> Quite a few quota race fixes are after 2.4.9. Its also going to depend
> entirely on your workload what works best.

Hmm, sounds like I am going to go with 2.4.18 on redhat 7.3 then.  I 
really don't want any quota trouble.

schu

