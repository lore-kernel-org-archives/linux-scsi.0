From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Tue, 29 Nov 2005 23:36:22 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0511292324000.5739@kai.makisara.local>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0511292147120.5739@kai.makisara.local>
 <20051129203112.GD6326@tau.solarneutrino.net> <Pine.LNX.4.63.0511292239070.5739@kai.makisara.local>
 <20051129205856.GE6326@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:34018 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S932423AbVK2VgE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Nov 2005 16:36:04 -0500
In-Reply-To: <20051129205856.GE6326@tau.solarneutrino.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 29 Nov 2005, Ryan Richter wrote:

> On Tue, Nov 29, 2005 at 10:48:22PM +0200, Kai Makisara wrote:
> > On Tue, 29 Nov 2005, Ryan Richter wrote:
> > > This applies cleanly to 2.6.14.2, do you forsee any problems using it
> > > with that kernel?  I'd like to not change too many things at once.
> > > 
> > No, I don't see any potential problems applying this patch to 2.6.14.2. 
> > There is nothing specific to 2.6.15-rc2.
> > 
> > If someone sees that there is something wrong, please yell. The 
> > main purpose of the patch is not to call release_buffering() at the end of 
> > st_write() when starting asynchronous write and call it in 
> > write_behind_check() instead.
> 
> OK, thanks.  I think I'll go ahead and advance to 2.6.14.3 since that
> should theoretically not cause any problems.
> 
> One question: do you think the oopses that happened later that actually
> crashed the box were from damage caused by this bug or is that a
> different problem?
> 
I looked at the oopses but, not knowing enough about what is happening 
inside the kernel, I can only hope that they are caused by the st bug(s). 
We will see after testing with the patch.

-- 
Kai
