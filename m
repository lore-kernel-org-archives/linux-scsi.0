From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] block: introduce REQ_FLUSH flag
Date: Sun, 27 Jun 2010 05:52:24 -0400
Message-ID: <20100627095223.GA6447@infradead.org>
References: <1277305652-2306-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1277305652-2306-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52916 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab0F0Jwd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Jun 2010 05:52:33 -0400
Content-Disposition: inline
In-Reply-To: <1277305652-2306-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: axboe@kernel.dk, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

> +++ b/include/linux/bio.h
> @@ -152,6 +152,7 @@ enum rq_flag_bits {
>  	__REQ_SYNC,		/* request is sync (sync write or read) */
>  	__REQ_META,		/* metadata io request */
>  	__REQ_DISCARD,		/* request to discard sectors */
> +	__REQ_FLUSH,		/* request for cache flush */

As we only used this in the request it should go into the struct request
only section at the end of the flags.

