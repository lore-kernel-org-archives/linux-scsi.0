From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 5 Mar 2008 16:27:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803051625450.4161-100000@iolanthe.rowland.org>
References: <47CF0D2E.7000607@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47CF0D2E.7000607-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 5 Mar 2008, Stefan Richter wrote:

> Alan Stern wrote:
> > This patch (as1050b) adds two new methods to the SCSI host template
> > structure.  These methods are called to notify lower-level drivers
> > when a block device below one of their hosts has been opened or
> > released.
> 
> I like it and would make use of it in sbp2.
> 
> sg, st, ch could be callers as well, but I suppose you don't really need 
> them.  And for me, sd and sr already cover 99.9% of the use cases.

Those drivers don't export a block-device interface, do they?  So you 
can't mount a filesystem on a device they control.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
