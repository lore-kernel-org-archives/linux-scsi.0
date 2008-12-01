From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: integrate blk_end_bidi_request into
	blk_end_request
Date: Mon, 1 Dec 2008 04:50:53 -0500
Message-ID: <20081201095053.GA6943@infradead.org>
References: <20081128145221I.fujita.tomonori@lab.ntt.co.jp> <493274A7.5050404@panasas.com> <20081201170000N.fujita.tomonori@lab.ntt.co.jp> <4933B198.7090309@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38882 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYLAJvI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 04:51:08 -0500
Content-Disposition: inline
In-Reply-To: <4933B198.7090309@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Mon, Dec 01, 2008 at 11:42:48AM +0200, Boaz Harrosh wrote:
> No I think (and said) that the API is crap. But not that bad that I want to
> take the effort and change it.

Get your ass of the chair and simply do it ;-)  This thread is a candidate
for everyone to waste more time arguing than takes to do the simple
interface change.

