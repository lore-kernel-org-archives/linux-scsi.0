From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Fri, 18 Jul 2003 15:35:24 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F17871C.4030306@cyberone.com.au>
References: <20030716132036.GB833@suse.de>	<1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>	<20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>	<3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>	<3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>	<3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>	<3F168846.90902@cyberone.com.au>	<1058474814.4638.11.camel@markh1.pdx.osdl.net>	<1058481553.19508.5.camel@markh1.pdx.osdl.net>	<1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>	<20030717170055.5dbe20c1.akpm@osdl.org>	<3F17821A.307@cyberone.com.au> <20030717222534.0295c44e.akpm@osdl.org> <3F1785D9.5000905@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-243-47.webone.com.au ([210.9.243.47]:3602 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S271702AbTGRFUl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Jul 2003 01:20:41 -0400
In-Reply-To: <3F1785D9.5000905@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: daniel@osdl.org, markh@osdl.org, axboe@suse.de, James.Bottomley@steeleye.com, cliffw@osdl.org, linux-scsi@vger.kernel.org



Nick Piggin wrote:

>
>
> Andrew Morton wrote:
>
>> Nick Piggin <piggin@cyberone.com.au> wrote:
>>
>>>
>>> Oh, so the request should go on the dispatch list?
>>> OK that makes sense. Maybe also set arq->state = AS_RQ_DISPATCHED
>>> just in case.
>>>
>>> And I think the arq == NULL case should be checked for with
>>> rq->flags & REQ_HARDBARRIER || !blk_fs_request(rq) for consistency.
>>> I think if arq is still NULL then its a bug.
>>>
>>
>> Guys, it's been three days and I'm getting a dribble of sad little 
>> messages
>> from various people whose boxes are stuck with everything in D state.
>>
>> Can we please get this thing wrapped up within the next 12 hours so we
>> don't spend all of next week with Linus's tree in such a blatantly buggy
>> state?
>>
>
> No, I think Mark's last patch with Daniel's and my suggestions
> should be fine. It fixes their problems. Its unfortunate that
> this bug never got caught until now but it was inevitable to be
> one or two there.
>
> I have been pretty worried about all the D state messages, but
> between this and the ReiserFS bug, I _think_ they have been
> found. If not, please forward me the reports because I haven't
> seen them. Thanks.
>

Andrew send the one line quick fix in to Linus if you like
until the complete fix is sorted out.


