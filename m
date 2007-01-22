From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Sun, 21 Jan 2007 19:24:56 -0500
Message-ID: <45B40458.9010107@torque.net>
References: <45B3F578.7090109@panasas.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42338 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbXAVAZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jan 2007 19:25:12 -0500
In-Reply-To: <45B3F578.7090109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>, Benny Halevy <bhalevy@panasas.com>

Boaz Harrosh wrote:
> - Introduce a new enum dma_data_direction data_dir member in struct request.
>   and remove the RW bit from request->cmd_flag
> - Add new API to query request direction.
> - Adjust existing API and implementation.
> - Cleanup wrong use of DMA_BIDIRECTIONAL
> - Introduce new blk_rq_init_unqueued_req() and use it in places ad-hoc
>   requests were used and bzero'ed.

With a bi-directional transfer is it always unambiguous
which transfer occurs first (or could they occur at
the same time)?

Doug Gilbert
