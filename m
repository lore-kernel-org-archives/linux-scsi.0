From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 2 Jul 2011 20:10:08 +0200
Message-ID: <20110702181008.GL23059@one.firstfloor.org>
References: <20110702060846.GH23059@one.firstfloor.org> <Pine.LNX.4.44L0.1107020837220.11097-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1107020837220.11097-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 02, 2011 at 08:38:20AM -0400, Alan Stern wrote:
> On Sat, 2 Jul 2011, Andi Kleen wrote:
> 
> > > I'm not able to reproduce it on a vanilla 3.0-rc5 system.  Can anybody
> > > give the exact sequence of steps you went through to trigger the bug?
> > 
> > Connect USB storage device with builtin fake CD rom. Wait for udisk
> > to mount it. Pull cable. udisk does umount. Oops.
> > 
> > I also got a log of the refcounting now if you want it.
> 
> Yes, please.  The excerpt that James posted isn't enough.  In 
> particular, it doesn't show what happens during device creation.

http://halobates.de/tmp/usb-pull-oops-ref

-Andi
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
