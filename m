From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 03/12] scsi-mq: Add support for multiple hardware queues
Date: Wed, 29 Oct 2014 13:22:29 +0100
Message-ID: <5450DC05.1010907@acm.org>
References: <5433E43D.3010107@acm.org> <5433E4AB.8030306@acm.org> <yq1k33losu7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:58468 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaJ2MWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 08:22:36 -0400
In-Reply-To: <yq1k33losu7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/28/14 03:01, Martin K. Petersen wrote:
>>>>>> "Bart" == Bart Van Assche <bvanassche@acm.org> writes:
>
> Bart> Allow a SCSI LLD to declare how many hardware queues it supports
> Bart> by setting Scsi_Host.nr_hw_queues before calling scsi_add_host().
>
> Bart> Note: it is assumed that each hardware queue has a queue depth of
> Bart> shost-> can_queue. In other words, the total queue depth per host
> Bart> is (number of hardware queues) * (shost->can_queue).
>
> I suggest you emphasize that assumption in the header file.
>
> Also: What about the host template?
>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Hello Martin,

Thanks for reviewing the blk-core and SCSI-core patches in this series. 
Regarding nr_hw_queues and the SCSI host template: setting that 
parameter in the host template is supported. I will mention this in the 
patch description. I will also clarify the queue size assumptions in 
scsi_host.h.

Bart.


