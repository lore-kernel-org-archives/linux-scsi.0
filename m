From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/5] block: remove end_{queued|dequeued}_request()
Date: Wed, 1 Oct 2008 16:19:27 +0200
Message-ID: <20081001141926.GG19428@kernel.dk>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:43321 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbYJAOUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 10:20:51 -0400
Content-Disposition: inline
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com

On Wed, Oct 01 2008, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> This patch-set removes end_queued_request() and end_dequeued_request(),
> which became identical by the blk_end_request patch-set:
>     http://marc.info/?l=linux-kernel&m=119741306502719&w=2
> 
> They just calls __blk_end_request() actually, so users of them are
> converted to call __blk_end_request() directly.
> There should be no functional change.
> 
> This patch-set was created on top of the commit below of for-2.6.28.
> ---------------------------------------------------------------------
> commit e857b07acc3f1352224f380fcbf26ef985116cc8
> Author: Sven Schuetz <sven@linux.vnet.ibm.com>
> Date:   Fri Sep 26 10:58:02 2008 +0200
> 
>     include blktrace_api.h in headers_install
> ---------------------------------------------------------------------
> 
> end_request() could be also removed, but it has been used by
> many old drivers and auditing all such codes will take a time.
> So this patch-set doesn't remove end_request().
> 
> Please review and apply.

Looks good, applied to the mix! Thanks.

-- 
Jens Axboe

