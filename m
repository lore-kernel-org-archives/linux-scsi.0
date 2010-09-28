From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UAS driver
Date: Tue, 28 Sep 2010 00:06:13 -0700
Message-ID: <20100928070613.GA11056@kroah.com>
References: <20100928050733.GB3799@linux.intel.com> <20100928055649.GB8922@kroah.com> <20100928064549.GD3799@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100928064549.GD3799-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 02:45:49AM -0400, Matthew Wilcox wrote:
> On Mon, Sep 27, 2010 at 10:56:49PM -0700, Greg KH wrote:
> > On Tue, Sep 28, 2010 at 01:07:34AM -0400, Matthew Wilcox wrote:
> > > +static struct usb_device_id uas_usb_ids[] = {
> > > +	{ USB_INTERFACE_INFO(8, 6, 0x50) },
> > > +	{ USB_INTERFACE_INFO(8, 6, 0x62) },
> > > +	{ USB_INTERFACE_INFO(8, 6, 0xaa) }, /* A prototype */
> > > +	{ }
> > 
> > Don't we have the proper #defines in the usb/ch9.h file that you can use
> > here?  If not, please add them so that we don't have "magic" numbers.
> 
> We've got
> #define USB_CLASS_MASS_STORAGE          8
> in usb/ch9.h, which I can use.

Good.

> The other numbers are in include/linux/usb_usual.h, which is actually a pain
> to include (I haven't figured out everything I need to do to include it).
> 
> What I'd like to do is pull the subclasses and protocols out into a new
> include file, include/linux/usb/storage.h to match audio.h.  Would you be
> likely to accept such a patch?

Sure, that would make sense.

> I don't intend to add 0xaa to a header file ... I see its inclusion in
> this driver as a temporary thing, and I'd rather remove support for it
> than add it to a header.

I'm afraid to ask what the 0xaa is, but here goes, what is it?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
