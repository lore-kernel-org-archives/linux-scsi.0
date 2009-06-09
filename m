From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: needs to set the residual length of a bidi request.
Date: Tue, 09 Jun 2009 11:59:37 +0900
Message-ID: <4A2DD019.6000503@kernel.org>
References: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:39903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZFIC7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 22:59:44 -0400
In-Reply-To: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This is against for-2.6.31.
> 
> This should fix the following problem:
> 
> http://marc.info/?l=linux-scsi&m=124449210813269&w=2
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: needs to set the residual length of a bidi request
> 
> Tejun's "block: set rq->resid_len to blk_rq_bytes() on issue" patch
> seems to be incomplete; It doesn't set rq->resid_len to blk_rq_bytes()
> for a bidi request (req->next_rq). As a result, all bidi users are
> broken.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
