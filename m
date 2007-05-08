From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: bidi bsg is non-blocking
Date: Tue, 8 May 2007 15:00:32 +0200
Message-ID: <20070508130032.GJ4163@kernel.dk>
References: <20070508162326Q.fujita.tomonori@lab.ntt.co.jp> <20070508163138G.fujita.tomonori@lab.ntt.co.jp> <20070508122134.GI4163@kernel.dk> <20070508215620M.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:34812 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967397AbXEHNCq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 09:02:46 -0400
Content-Disposition: inline
In-Reply-To: <20070508215620M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Daniel.E.Messinger@seagate.com, tomof@acm.org, linux-scsi@vger.kernel.org

On Tue, May 08 2007, FUJITA Tomonori wrote:
> BTW, any comments on the bidi patch for the block layer?

Yeah it looks much better. I agree with your notion that bidi should be
block layer agnostic at least for now (until a general use comes up),
it's just a way to transport these commands. And I do still prefer
->next_rq as the pointer name for partly those reasons.

-- 
Jens Axboe

