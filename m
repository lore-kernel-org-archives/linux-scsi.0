From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: PATCH: (as141) Unaligned scatter-gather buffers and usb-storage
Date: Fri, 21 Nov 2003 22:07:23 +0200 (EET)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.58.0311212202150.1627@kai.makisara.local>
References: <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0311211249230.1381-100000@ida.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Douglas Gilbert <dougg@torque.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, James Bottomley <James.Bottomley@steeleye.com>, Patrick Mansfield <patmans@us.ibm.com>, Jens Axboe <axboe@suse.de>, Oliver Neukum <oliver@neukum.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB development list <linux-usb-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

On Fri, 21 Nov 2003, Alan Stern wrote:

> I'm not sure whether Jens is objecting to adding the extra member to the
> host template or to making the default alignment something other than 512.
> Here's my attempt at a compromise patch, which boils the area of
> disagreement between Kai and Jens down to a single line of code (plus a
> comment).  It doesn't change the host template and it shouldn't slow down
> any tape I/O programs when using a non-USB device.
>
Looks very good. Using existing mechanisms is better than adding a new
member to a struct.

I tested the patch with a tape and did not find any problems.

> If there aren't any more objections to this, I urge James to apply the
> SCSI parts to a post-2.6.0-final tree, and likewise for Matt and the USB
> part.
>
As far as I am concerned, please do.

-- 
Kai


-------------------------------------------------------
This SF.net email is sponsored by: SF.net Giveback Program.
Does SourceForge.net help you be more productive?  Does it
help you create better code?  SHARE THE LOVE, and help us help
YOU!  Click Here: http://sourceforge.net/donate/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
