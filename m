From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 04/12] scsi_tcq.h: Add support for multiple hardware
 queues
Date: Tue, 21 Oct 2014 11:59:27 +0300
Message-ID: <5446206F.7020401@dev.mellanox.co.il>
References: <5433E43D.3010107@acm.org> <5433E4C4.4030104@acm.org> <5443E2DF.1040605@dev.mellanox.co.il> <5444F995.5080407@acm.org> <20141021084952.GC10407@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50418 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbaJUI7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Oct 2014 04:59:33 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so9390027wiv.8
        for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2014 01:59:32 -0700 (PDT)
In-Reply-To: <20141021084952.GC10407@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/21/2014 11:49 AM, Christoph Hellwig wrote:
> On Mon, Oct 20, 2014 at 02:01:25PM +0200, Bart Van Assche wrote:
>> On 10/19/14 18:12, Sagi Grimberg wrote:
>>> On 10/7/2014 4:04 PM, Bart Van Assche wrote:
>>>> -            req = blk_queue_find_tag(sdev->request_queue, tag);
>>>> +        req = blk_queue_find_tag(sdev->request_queue, tag);
>>>
>>> Why is this line different?
>>
>> This is because the indentation has been modified from "8x<space><tab>" into
>> "<tab><tab>". I can leave out that change if you want.
>
> Please keep it.
>

I don't have a big objection on this, but the problem with leaving this
stuff is that it tends to screw up git blame...
