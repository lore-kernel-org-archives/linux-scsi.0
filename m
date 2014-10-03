From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 03 Oct 2014 08:24:05 -0600
Message-ID: <542EB185.2040506@kernel.dk>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com> <541C4D2F.9060907@acm.org> <541C4DF1.4090604@kernel.dk> <542C270B.5020002@acm.org> <542C31C4.1020702@kernel.dk> <542D8143.3050305@acm.org> <542D8368.8080604@kernel.dk> <542E9E10.8040207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:48588 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaJCOYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2014 10:24:09 -0400
Received: by mail-pa0-f44.google.com with SMTP id et14so1636566pad.3
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2014 07:24:08 -0700 (PDT)
In-Reply-To: <542E9E10.8040207@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Ming Lei <ming.lei@canonical.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Robert Elliott <Elliott@hp.com>

On 2014-10-03 07:01, Bart Van Assche wrote:
> On 10/02/14 18:55, Jens Axboe wrote:
>> Sure, that's fine as well, but the function needs a more descriptive
>> name. I try to think of it like I have never looked at the code and need
>> to write a driver, it's a lot easier if the functions are named
>> appropriately. Seeing blk_mq_rq_tag() and even with reading the function
>> comment, I'm really none the wiser and would assume I need to use this
>> function to get the tag.
>>
>> So we can do the single function, but lets call it
>> blk_mq_unique_rq_tag(). That's special enough that people will know this
>> is something that doesn't just return the request tag. Then add an extra
>> sentence to the comment you already have on when this is needed.
>>
>> And lets roll those bitshift values and masks into a define or enum so
>> it's collected in one place.
>
> How about the patch below ? In that patch all comments should have been
> addressed that Christoph and you have formulated so far.

Looks good to me now. Get rid of the extra TAG in the 
BLK_MQ_UNIQUE_TAG_TAG_BITS/MASK naming though, then you can add my 
acked-by if Christoph wants to take this through the scsi tree.

-- 
Jens Axboe

