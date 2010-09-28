From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH] UAS driver
Date: Tue, 28 Sep 2010 03:17:11 -0400
Message-ID: <20100928071711.GE3799@linux.intel.com>
References: <20100928050733.GB3799@linux.intel.com>
 <20100928055649.GB8922@kroah.com>
 <20100928064549.GD3799@linux.intel.com>
 <20100928070613.GA11056@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100928070613.GA11056-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 12:06:13AM -0700, Greg KH wrote:
> > I don't intend to add 0xaa to a header file ... I see its inclusion in
> > this driver as a temporary thing, and I'd rather remove support for it
> > than add it to a header.
> 
> I'm afraid to ask what the 0xaa is, but here goes, what is it?

It's a prototype device that has the wrong protocol ID.  Eventually I'll
just drop support for it from the driver, but it's a useful device
to keep testing with for the moment (it supports some aspects of the
protocol that other devices I have access to don't).

Since nobody else is likely to have one, I'd rather take the line out
of the in-tree driver and patch it back in locally, than I would add it
to the header file.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
