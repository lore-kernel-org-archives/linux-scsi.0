From: Oliver Neukum <oliver@neukum.name>
Subject: Re: PATCH: usb-storage: move to SCSI hotplugging
Date: Sun, 19 Jan 2003 23:56:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200301192356.01601.oliver@neukum.name>
References: <20030119143058.A31114@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030119143058.A31114@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, Linux SCSI list <linux-scsi@vger.kernel.org>

Am Sonntag, 19. Januar 2003 23:30 schrieb Matthew Dharm:
> The attached patch is my first implementation of SCSI hotplugging.
>
> It's only been tested that it compiles, as I can't get the current
> linux-2.5 tree from linuxusb to boot.  It dies _very_ early.  Greg, I'm not

Just a black screen?
I suffered from the same problem until today. The key was to compile
without VGA mode selection.

> sure if you'll want to apply this.  Linus seemed to want this very much,
> and it is 2.5.x... I say go for it, but I can understand if you have
> reservations.
>
> I would definately like to see this tested by anyone who can get a kernel
> to boot.

Sorry, no storage device :-(

As for the patch itself, it's quite hard to grasp something of this size.
Is the information previously used to make GUID available to other parts
of the kernel? Otherwise I think you should not cut it out, but only remove
the reattachment part.

	Regards
		Oliver

