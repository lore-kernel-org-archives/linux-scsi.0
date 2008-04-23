From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] block: add dma alignment and padding support to
 blk_rq_map_kern
Date: Wed, 23 Apr 2008 16:05:33 +0900
Message-ID: <20080423160451X.tomof@acm.org>
References: <20080419202757Z.tomof@acm.org>
	<480ED7F9.8080700@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:53956 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbYDWHFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 03:05:49 -0400
In-Reply-To: <480ED7F9.8080700@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: htejun@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com

On Wed, 23 Apr 2008 15:32:25 +0900
Tejun Heo <htejun@gmail.com> wrote:

> FUJITA Tomonori wrote:
> > blk_rq_map_kern ignores dma alignment and padding. Is it problematic
> > to libata?
> 
> Till now we've been depending for the issuer to get this right but it's 
> definitely worth fixing.  Thanks.

Surely, some callers don't give 512-byte aligned buffer, which libata
wants.
