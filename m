From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 21:01:17 -0400
Message-ID: <20100929010117.GD4689@linux.intel.com>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com>
 <1285668896-6356-2-git-send-email-willy@linux.intel.com>
 <20100928175122.GE25677@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100928175122.GE25677-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 10:51:22AM -0700, Matthew Dharm wrote:
> On Tue, Sep 28, 2010 at 06:14:56AM -0400, Matthew Wilcox wrote:
> > From: Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > USB Attached SCSI is a new protocol specified jointly by the SCSI T10
> > committee and the USB Implementors Forum.
> > 
> > Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > ---
> >  MAINTAINERS                  |    8 +
> >  drivers/usb/storage/Kconfig  |   13 +
> >  drivers/usb/storage/Makefile |    1 +
> >  drivers/usb/storage/uas.c    |  751 ++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 773 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/usb/storage/uas.c
> 
> Given that this is distinctly not usb-storage, and it is entirely contained
> within a single file, does it really belong in the drivers/usb/storage
> directory?

Well.  It's USB Storage, specified as part of the Mass Storage Class
Specification Overview 1.4.  It's not part of the Linux usb-storage driver
(yet?), but it's really closely related.  For one thing, UAS devices
come up in BBB (aka BOT) mode and have to be switched to UAS mode.
That might be an argument for integration with libusual, or it might
be an argument for integration with usb-storage.  I have no idea yet,
I'm still experimenting.

Either way, there's got to be close cooperation, and being in the same
directory seems like a minimum requirement.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
