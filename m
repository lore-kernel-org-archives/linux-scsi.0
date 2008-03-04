From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 13:39:40 +0100
Message-ID: <20080304123939.GM6704@kernel.dk>
References: <20080304175302T.fujita.tomonori@lab.ntt.co.jp> <20080304085944.GG6704@kernel.dk> <20080304180648W.fujita.tomonori@lab.ntt.co.jp> <20080304182228Z.fujita.tomonori@lab.ntt.co.jp> <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15231 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbYCDMjn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 07:39:43 -0500
Content-Disposition: inline
In-Reply-To: <1204634238.5997.5.camel@homer.simson.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, htejun@gmail.com, tomof@acm.org, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com

On Tue, Mar 04 2008, Mike Galbraith wrote:
> 
> On Tue, 2008-03-04 at 10:35 +0100, Jens Axboe wrote:
> 
> > Looks excellent to me, has a variant of this been tested as OK by the
> > users reporting the regression?
> 
> K3b burning seems to be a nogo here.  This is git pulled this morning
> though, so it's a somewhat different tree than previously tested fwtw.

can you please try git as of this morning without any patches applied,
and then pull

git://git.kernel.dk/linux-2.6-block.git for-linus

into that and see if that works?

-- 
Jens Axboe

