From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: usb storage traces
Date: Sat, 20 Dec 2003 21:26:19 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0312202124070.27646-100000@netrider.rowland.org>
References: <20031220235651.GE8787@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:56078 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S262050AbTLUC0U
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2003 21:26:20 -0500
In-Reply-To: <20031220235651.GE8787@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Pat LaVarre <p.lavarre@ieee.org>, David Brownell <david-b@pacbell.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, USB Storage List <usb-storage@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 20 Dec 2003, Matthew Dharm wrote:

> Looking at your traces, I don't see any MODE SENSE commands.  I find that
> odd, especially since earlier traces show that data.
> 
> Looking at them, I'm starting to suspect that you need to have a valid
> filesystem there before Windows will issue that command.  What an odd way
> to do things....

Could be.  Or it could be a difference between Windows ME and Windows 
2000.

> Anyway, could you add that to your test cases?

I will.

> The data you've provided so far is excellent.

Thank you.  More to come after the holidays.

Alan Stern

