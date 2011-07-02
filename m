From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
Date: Sat, 02 Jul 2011 12:09:26 -0500
Message-ID: <1309626567.2554.11.camel@mulgrave>
References: <1309554818.2722.48.camel@mulgrave>
	 <Pine.LNX.4.44L0.1107012200260.4273-100000@netrider.rowland.org>
	 <20110702060846.GH23059@one.firstfloor.org>
	 <1309609482.2554.8.camel@mulgrave>
	 <20110702170554.GJ23059@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110702170554.GJ23059-qrUzlfsMFqo/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-07-02 at 19:05 +0200, Andi Kleen wrote:
> > Which goes from the device unplug to the oops.  However, there are puts
> > missing from this; particularly the one where the reference goes to
> > zero.
> 
> The count was always one off because it dumps it before the actual
> put.

I know this.  What I mean is the last seen put count before the oops is
3 (not 1).

And the transition after unplug goes

13->12->10->8->7->6->5->3

implying we're missing put events.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
