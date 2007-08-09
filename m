From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] sg: increase sglist_len of the sg_scatter_hold structure
Date: Thu, 09 Aug 2007 10:33:20 +0300
Message-ID: <46BAC340.4060402@panasas.com>
References: <46B600F4.7020601@torque.net>	<20070806130944R.fujita.tomonori@lab.ntt.co.jp>	<46B8A845.4080106@cs.wisc.edu> <20070808073801U.fujita.tomonori@lab.ntt.co.jp> <46B9F626.9020200@cs.wisc.edu> <46B9FB6B.70501@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21577 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764900AbXHIHfy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Aug 2007 03:35:54 -0400
In-Reply-To: <46B9FB6B.70501@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, dougg@torque.net, tomof@acm.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com

Mike Christie wrote:
> Mike Christie wrote:
>> For drivers like sg and st, do mean the the sg list that is passed to 
>> functions like scsi_execute_async? If we kill that argument, and instead 
>> have sg.c and other scsi_execute_async callers just call blk helpers 
>> like blk_rq_map_user then we would not have to worry about drivers like 
>> sg needing to know about chaining right? I mean sg.c would not every 
>> interact with a scatterlist. It would just interact with a request and 
>> the blk helpers map data for it.
> 
> There should be a return there.
> 
>   The scatterlist that sg and st interact
>> with is bogus. It gets thrown away in scsi_execute_async and is only 
>> used for book keeping.
> 
> I mean currently the scatterlist that sg and st use is bogus and gets 
> thrown away. If we convert sg and st to use blk_rq_map_user then those 
> drivers will not have to interact with a scatterlist at all.

I'm not familiar with the dire details but this sounds like a good idea.

Benny

