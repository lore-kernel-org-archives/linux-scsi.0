From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] block: implement mixed merge of different failfast
 requests
Date: Thu, 09 Jul 2009 09:47:50 +0900
Message-ID: <4A553E36.8060006@kernel.org>
References: <1246610898-22350-1-git-send-email-tj@kernel.org> <1246610898-22350-4-git-send-email-tj@kernel.org> <4A507203.8020001@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755811AbZGIAsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 20:48:06 -0400
In-Reply-To: <4A507203.8020001@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Niel Lambrechts <niel.lambrechts@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <axboe@kernel.dk>

Hello,

Boaz Harrosh wrote:
>> @@ -1165,6 +1165,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
>>  	const unsigned short prio = bio_prio(bio);
>>  	const int sync = bio_sync(bio);
>>  	const int unplug = bio_unplug(bio);
>> +	const unsigned int ff = bio->bi_rw & REQ_FAILFAST_MASK;
> 
> Perhaps a bio_fail_fast(bio)
> and also an blk_failfast(rq).

Me not being a big fan of those simple accessors, I want to avoid
adding those especially the use of bio ones are mostly confined to
block layer proper.

Thanks.

-- 
tejun
