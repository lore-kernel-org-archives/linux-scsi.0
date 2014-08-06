From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 6 Aug 2014 16:25:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408061621460.1145-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1408061545030.1145-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1408061545030.1145-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tiziano Bacocco <tiziano.bacocco-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Please don't remove names from the CC: list; use Reply-To-All.  I had 
to go back and add all the names back in.

On Wed, 6 Aug 2014, Tiziano Bacocco wrote:

> Test with alcor based USB flash drives, linux 3.16 will remove the 3 msb of
> the CDB byte when using SG raw

Sure, but isn't that what you want it to do?  Doesn't the flash drive 
use those bits to hold the LUN number?

Alan Stern


> Il 06/ago/2014 22:02 "Alan Stern" <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org> ha scritto:
>
> > On Wed, 6 Aug 2014, Christoph Hellwig wrote:
> >
> > > On Wed, Aug 06, 2014 at 03:29:47PM +0200, Douglas Gilbert wrote:
> > > > If not and since I'm told black lists and the like won't
> > > > work, my advice for the record is to use FreeBSD or Windows
> > > > for tools that need this capability.
> > >
> > > I doubt either of them forces users to hack up flags for these cases.
> >
> > Why was this change needed in the first place?  There's no explanation
> > in the patch itself.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
