From: Chris Clayton <chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: 2,6.26-rc4-git2 - long pause during boot
Date: Tue, 10 Jun 2008 18:49:12 +0000
Message-ID: <200806101849.12637.chris2553@googlemail.com>
References: <200806010415.05290.chris2553@googlemail.com> <1212950276.3574.7.camel@localhost.localdomain> <20080609230747.GD23391@kroah.com>
Reply-To: chris2553-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080609230747.GD23391-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Monday 09 June 2008, Greg KH wrote:
> On Sun, Jun 08, 2008 at 01:37:56PM -0500, James Bottomley wrote:
> > > Because of this oddity, I've also built 2.6.26-rc5-git2 with verbose
> > > USB debugging on. A boot log from that kernel is attached. You will see
> > > lots of ETIME errors from usb. A log from a similarly verbose 2.6.25.5
> > > kernel does not show these errors. usb-devel added to cc list.
> >
> > I'm starting to think this might be a distribution problem.  I tried
> > booting my laptop on your config (only system I have with ata_piix)
> > without an initrd (bit painful for fedora 9) and I didn't see any slow
> > downs (in fact it was a lot faster than previously; makes note to file
> > bug with redhat about their initramfs).
>
> What distro is this being seen on?  I know that openSUSE 11.0 betas did
> have a bug in their init scripts that was causing a long delay, much
> like this one.  But it has been fixed in the later releases
> (hopefully...)
>

As I repied to James a few minutes ago, my desktop system was originally (the 
now lapsed) Peanut Linux, which was a Slackware derivative. But I've been 
running it for 3 or 4 years, upgrading and adding packages along the way. My 
udev setup is based on that in a fairly recent Slackware, although I can't now 
recall precisely which version.

Thanks

Chris

> thanks,
>
> greg k-h



-- 
Beauty is in the eye of the beerholder.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
