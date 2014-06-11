From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v2] sg: add SG_FLAG_Q_AT_TAIL flag
Date: Wed, 11 Jun 2014 16:14:58 -0500
Message-ID: <5398C6D2.2020404@cs.wisc.edu>
References: <538F3416.5090306@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39774 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaFKVP6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jun 2014 17:15:58 -0400
In-Reply-To: <538F3416.5090306@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <JBottomley@parallels.com>, openosd@gmail.com

On 06/04/2014 09:58 AM, Douglas Gilbert wrote:
> When the SG_IO ioctl was copied into the block layer and
> later into the bsg driver, subtle differences emerged.
> 
> One difference is the way injected commands are queued through
> the block layer (i.e. this is not SCSI device queueing nor SATA
> NCQ). Summarizing:
>   - SG_IO in the block layer: blk_exec*(at_head=false)
>   - sg SG_IO: at_head=true
>   - bsg SG_IO: at_head=true
> 
> Some time ago Boaz Harrosh introduced a sg v4 flag called
> BSG_FLAG_Q_AT_TAIL to override the bsg driver default.
> This patch does the equivalent for the sg driver.
> 
> 
> ChangeLog:
>     Introduce SG_FLAG_Q_AT_TAIL flag to cause commands
>     to be injected into the block layer with
>     at_head=false.
> 
> Changes since v1:
>     Make guard condition (only take sg v3 interface or later
>     invocations) clearer.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
