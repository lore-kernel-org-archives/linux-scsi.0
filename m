From: Pavel Machek <pavel@ucw.cz>
Subject: Re: SCSI power management for AHCI
Date: Sat, 19 Jan 2008 16:02:35 +0100
Message-ID: <20080119150235.GH24512@elf.ucw.cz>
References: <20080115201114.GA7219@elf.ucw.cz> <Pine.LNX.4.44L0.0801161020190.4431-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43626 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754003AbYASPCU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jan 2008 10:02:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0801161020190.4431-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-pm@lists.linux-foundation.org

On Wed 2008-01-16 10:21:35, Alan Stern wrote:
> On Tue, 15 Jan 2008, Pavel Machek wrote:
> 
> > Hi!
> > 
> > This is my first attempt at ahci autosuspend. It is _very_ hacky at
> > this moment, I'll seriously need to clean it up. But it seems to work
> > here.
> 
> How does this interact with Link Power Management?  Should there be 
> a stronger connection between the two?

Link Power Management seems to be hw stuff, and I do not think much
linking is neccessary.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
