From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20
 [sr_mod]
Date: Sat, 9 Jan 2016 11:36:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1601091130560.7068-100000@netrider.rowland.org>
References: <1452353032.1150.4.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:38976 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756136AbcAIQgP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2016 11:36:15 -0500
In-Reply-To: <1452353032.1150.4.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <paul.menzel@giantmonkey.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, "James E. J. Bottomley" <JBottomley@odin.com>, SCSI development list <linux-scsi@vger.kernel.org>, 801925@bugs.debian.org, Erich Schubert <erich@debian.org>, Alexandre Rossi <alexandre.rossi@gmail.com>

On Sat, 9 Jan 2016, Paul Menzel wrote:

> Version: 4.4~rc8-1~exp1
> 
> Dear Alan,
> 
> 
> Thank you for your help!
> 
> There were some follow-ups to the bug report [1], but I think you and I
> were not in CC.

I wasn't.

> > 	http://marc.info/?l=linux-scsi&m=144185206825609&w=2
> > 	http://marc.info/?l=linux-scsi&m=144185208525611&w=2

> I can only say, that I am still unable to boot my system with Linux
> 4.4-rc8 [2]. Are these patches included there?

They are.  I don't see how they could cause a NULL pointer dereference 
in sd_resume(), though.  If you revert them, does the problem go away?

Also, can you add some debugging statements to sd_resume() so we can 
see where the NULL pointer comes from?

Alan Stern

