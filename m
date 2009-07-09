From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH]: Rename REQ_COPY_USER to more descriptive
	REQ_HAS_TAIL_SPACE_FOR_PADDING
Date: Thu, 9 Jul 2009 20:17:13 +0200
Message-ID: <20090709181713.GQ23611@kernel.dk>
References: <4A563259.5000601@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:46033 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbZGISRO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 14:17:14 -0400
Content-Disposition: inline
In-Reply-To: <4A563259.5000601@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Thu, Jul 09 2009, Vladislav Bolkhovitin wrote:
> Currently names of REQ_COPY_USER and __REQ_COPY_USER constants are confusing,
> because they actually mean that the buffer for the corresponding requests
> has space in the tail for padding in case of DMA padding restrictions.

No, that's not what it means, the fact that there's padding room is a
side effect of the map type. So I'd suggest adding a comment above that
if {} in blk_rq_map_sg(), something that should have been there from the
beginning.

-- 
Jens Axboe

