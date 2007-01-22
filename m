From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Mon, 22 Jan 2007 08:06:50 +0200
Message-ID: <45B4547A.3020105@panasas.com>
References: <45B3F578.7090109@panasas.com> <45B40458.9010107@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:53698 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804AbXAVGIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 01:08:13 -0500
In-Reply-To: <45B40458.9010107@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>

Douglas Gilbert wrote:
> Boaz Harrosh wrote:
>> - Introduce a new enum dma_data_direction data_dir member in struct request.
>>   and remove the RW bit from request->cmd_flag
>> - Add new API to query request direction.
>> - Adjust existing API and implementation.
>> - Cleanup wrong use of DMA_BIDIRECTIONAL
>> - Introduce new blk_rq_init_unqueued_req() and use it in places ad-hoc
>>   requests were used and bzero'ed.
> 
> With a bi-directional transfer is it always unambiguous
> which transfer occurs first (or could they occur at
> the same time)?

The bidi transfers can occur in any order and in parallel.

> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

