From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: needs to set the residual length of a bidi
	request.
Date: Tue, 9 Jun 2009 05:45:43 +0200
Message-ID: <20090609034542.GU11363@kernel.dk>
References: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:59655 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbZFIDpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 23:45:41 -0400
Content-Disposition: inline
In-Reply-To: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tj@kernel.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jun 09 2009, FUJITA Tomonori wrote:
> This is against for-2.6.31.
> 
> This should fix the following problem:
> 
> http://marc.info/?l=linux-scsi&m=124449210813269&w=2

Thanks, applied

-- 
Jens Axboe

