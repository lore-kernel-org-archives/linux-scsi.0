From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 23 Mar 2003 19:39:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048469946.1643.2.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030323173733.B24668@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Sun, 2003-03-23 at 19:37, Matthew Dharm wrote:
> Actually, there is such a list.  It's the commands that the 'popular OS'
> uses, and I have a pretty good idea exactly what those are.  That's why my
> original approach was to just cut out the commands that fell outside that
> definition.

Well, if you want to write a helper for the mid layer that checks the
commands and returns a Check Condition with sense Illegal Reguest on the
bad ones, that sounds like the best approach.  You can then call the
helper function in the queuecommand of the problem emulated drivers.

Can you publish a rough list of these?

James


