From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 02/12] blk-mq: Add blk_mq_unique_tag()
Date: Mon, 13 Oct 2014 11:21:54 +0200
Message-ID: <543B99B2.1010307@acm.org>
References: <5433E43D.3010107@acm.org> <5433E493.9030304@acm.org> <20141011110841.GA9593@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:34451 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbaJMJ1A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Oct 2014 05:27:00 -0400
In-Reply-To: <20141011110841.GA9593@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/11/14 13:08, Christoph Hellwig wrote:
>> +static inline u32 blk_mq_build_unique_tag(int hwq, int tag)
>> +{
>> +	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) | (tag & BLK_MQ_UNIQUE_TAG_MASK);
>> +}
>
> Is there any value in having this as a separate helper?

Hello Christoph,

With the approach for block layer tag management proposed in this patch 
series SCSI LLDs no longer need to call this function. This means that 
the blk_mq_build_unique_tag() function can be eliminated by inlining it 
into blk_mq_unique_tag(). Would you like me to rework this patch 
accordingly ?

Bart.

