From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Tue, 4 Mar 2008 12:43:04 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803041237440.4039-100000@iolanthe.rowland.org>
References: <1204649571.3091.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1204649571.3091.36.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Mar 2008, James Bottomley wrote:

> If you want to see for yourself, it's fs/block_dev.c:do_open().

Thanks for the pointer.  I see the subroutine is not exactly loaded 
with comments...

> > If you can suggest an alternative approach, I'll be glad to change the
> > patch.
> 
> Well, since this is the 7th patch of an eight patch series, I don't
> really have the context for that.  However, I assume it's all on the
> linux-usb list?  If so, I'll add it to my list of things to look at.

The patches before it probably won't give you any additional useful 
context.  The following patch might; that's the one affecting 
usb-storage.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
