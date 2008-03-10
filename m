From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 01/10] block: add sg buffer copy helper functions
Date: Mon, 10 Mar 2008 15:37:49 +0100
Message-ID: <20080310143749.GZ17940@kernel.dk>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:13827 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbYCJOhx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2008 10:37:53 -0400
Content-Disposition: inline
In-Reply-To: <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, tomof@acm.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Sun, Mar 09 2008, FUJITA Tomonori wrote:
> This patch adds new two helper functions to copy data between an SG
> table and liner buffer.
> 
> - sg_copy_from_buffer copies data from liner buffer to an SG table
> - sg_copy_to_buffer copies data from an SG table to liner buffer
> 
> sg_copy_from_buffer always call flush_kernel_dcache_page. It's not
> necessary for everyone but it's a no-op on most architectures and in
> general the API is not used in performance critical path.

Looks good!

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

