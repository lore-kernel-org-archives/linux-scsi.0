From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Fri, 01 Aug 2003 08:48:22 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F299CB6.7030104@cyberone.com.au>
References: <20030716132036.GB833@suse.de>	 <1058364455.1856.28.camel@mulgrave>	<20030716170456.GK833@suse.de>	 <20030717015756.135a3f5a.akpm@osdl.org>	<20030717085952.GX833@suse.de>	 <3F1672D9.7070309@cyberone.com.au>	<20030717102926.GE833@suse.de>	 <3F167F98.60006@cyberone.com.au>	<20030717105641.GF833@suse.de>	 <3F1683F5.4030107@cyberone.com.au>	<20030717111059.GI833@suse.de>	 <3F168846.90902@cyberone.com.au>	 <1058474814.4638.11.camel@markh1.pdx.osdl.net>	 <1058481553.19508.5.camel@markh1.pdx.osdl.net>	 <1058485621.7424.30.camel@dell_ss5.pdx.osdl.net>	 <20030717170055.5dbe20c1.akpm@osdl.org>  <3F17821A.307@cyberone.com.au>	 <1058540605.20130.48.camel@markh1.pdx.osdl.net>	 <1058545730.20130.62.camel@markh1.pdx.osdl.net>	 <1058547377.1826.61.camel@mulgrave>	 <1058550386.20130.75.camel@markh1.pdx.osdl.net>	 <1058559719.1826.106.camel@mulgrave>  <3F28C24B.2020604@cyberone.com.au> <1059662443.27432.2.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-244-141.webone.com.au ([210.9.244.141]:9220 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S274882AbTGaWtZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2003 18:49:25 -0400
In-Reply-To: <1059662443.27432.2.camel@markh1.pdx.osdl.net>
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, Daniel McNeil <daniel@osdl.org>, Jens Axboe <axboe@suse.de>, Cliff White <cliffw@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>



Mark Haverkamp wrote:

>On Thu, 2003-07-31 at 00:16, Nick Piggin wrote:
>
>>James Bottomley wrote:
>>
>>
>>>On Fri, 2003-07-18 at 12:46, Mark Haverkamp wrote:
>>>
>>>
>>>>I'll try out your test harness on our hardware and see what happens.
>>>>
>>>>
>>Sorry for coming in a few weeks late here. Thanks everyone who
>>has been taking time on this.
>>
>>What is the status of this stuff? I see Andrew's latest tree still
>>has your "HACK: ***" in it, James. Who is putting together a complete
>>patch for Andrew?
>>
>>
>>>OK, I think I found the problem.
>>>
>>>
>>Yes, the problem with AS just the I-don't-know-about-requeue thing.
>>As you have found there are other non AS problems there.
>>
>>Thanks again everyone.
>>
>
>Nick,
>
>Here is the requeue function I have been using for a while.  It is based
>on your original requeue function.  It has been working for me.
>

Yeah, the patch looks good. James, can you test when you get time
please? Then Mark can send to Andrew. Thanks.


