From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Fri, 8 Jun 2007 17:20:49 +0200
Message-ID: <20070608152049.GT7341@kernel.dk>
References: <20070604140414.GI32105@kernel.dk> <200706042203.l54M3rtf031762@mbox.iij4u.or.jp> <20070607112309.GY4735@kernel.dk> <20070608132326B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:28106 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbXFHPW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jun 2007 11:22:29 -0400
Content-Disposition: inline
In-Reply-To: <20070608132326B.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org

On Sat, Jun 09 2007, FUJITA Tomonori wrote:
> I'll submit the bsg bidi patches shortly.

Great - I see them, will review and integrate next week.

-- 
Jens Axboe

