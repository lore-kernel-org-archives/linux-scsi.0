From: Ryan Richter <ryan@tau.solarneutrino.net>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Tue, 29 Nov 2005 15:58:56 -0500
Message-ID: <20051129205856.GE6326@tau.solarneutrino.net>
References: <20051129092432.0f5742f0.akpm@osdl.org> <Pine.LNX.4.63.0511292147120.5739@kai.makisara.local> <20051129203112.GD6326@tau.solarneutrino.net> <Pine.LNX.4.63.0511292239070.5739@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from solarneutrino.net ([66.199.224.43]:60932 "EHLO
	tau.solarneutrino.net") by vger.kernel.org with ESMTP
	id S932403AbVK2U7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 15:59:00 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.63.0511292239070.5739@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ryan@tau.solarneutrino.net

On Tue, Nov 29, 2005 at 10:48:22PM +0200, Kai Makisara wrote:
> On Tue, 29 Nov 2005, Ryan Richter wrote:
> > This applies cleanly to 2.6.14.2, do you forsee any problems using it
> > with that kernel?  I'd like to not change too many things at once.
> > 
> No, I don't see any potential problems applying this patch to 2.6.14.2. 
> There is nothing specific to 2.6.15-rc2.
> 
> If someone sees that there is something wrong, please yell. The 
> main purpose of the patch is not to call release_buffering() at the end of 
> st_write() when starting asynchronous write and call it in 
> write_behind_check() instead.

OK, thanks.  I think I'll go ahead and advance to 2.6.14.3 since that
should theoretically not cause any problems.

One question: do you think the oopses that happened later that actually
crashed the box were from damage caused by this bug or is that a
different problem?

> > If it should be OK, I'll boot this tonight or tomorrow - the backups run
> > every other night, so it won't get any testing until tomorrow night.
> > 
> > Thanks a lot,
> > -ryan
> > 
> Thanks for reporting the problem and thanks in advance for testing.

Sure thing,
-ryan
