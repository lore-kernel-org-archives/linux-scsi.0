From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Mon, 9 Jul 2007 22:02:58 +0900
Message-ID: <20070708153520O.fujita.tomonori@acm.org>
References: <20070608152049.GT7341@kernel.dk>
	<20070620223131L.fujita.tomonori@lab.ntt.co.jp>
	<20070709122643.GT5267@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38775 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbXGINRd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 09:17:33 -0400
In-Reply-To: <20070709122643.GT5267@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
Date: Mon, 9 Jul 2007 14:26:44 +0200

> On Wed, Jun 20 2007, FUJITA Tomonori wrote:
> > From: Jens Axboe <jens.axboe@oracle.com>
> > Subject: Re: [PATCH] bsg: fix the deadlock on discarding done commands
> > Date: Fri, 8 Jun 2007 17:20:49 +0200
> > 
> > > On Sat, Jun 09 2007, FUJITA Tomonori wrote:
> > > > I'll submit the bsg bidi patches shortly.
> > > 
> > > Great - I see them, will review and integrate next week.
> > 
> > Any progress on this?
> 
> Please resend the bsg bidi patches so I can integrate them, thanks.

Great!

I've just sent the patchset against the latest your bsg branch.

BTW, seems that you forget to add my sign-off in the last two patches
in the bsg branch.

Thanks.
