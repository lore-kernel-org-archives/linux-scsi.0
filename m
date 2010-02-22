From: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Mon, 22 Feb 2010 13:06:39 +0000
Message-ID: <1266843999.4414.27.camel@mulgrave.site>
References: <3e7aae31002170437i52ba4ba1w10c1ff224d9b37ef@mail.gmail.com>
	 <1266418952.2787.5.camel@mulgrave.site>
	 <3e7aae31002180046i771f2e1encfcda864f564c87e@mail.gmail.com>
	 <1266508049.4355.37.camel@mulgrave.site>
	 <3e7aae31002190443w44418778u6180c74d51a0f783@mail.gmail.com>
	 <1266589605.2822.2.camel@mulgrave.site>
	 <3e7aae31002220450o6f83d2f3n45c795d70ef01f72@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3e7aae31002220450o6f83d2f3n45c795d70ef01f72-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ramya Desai <ramya.desai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2010-02-22 at 18:20 +0530, Ramya Desai wrote:
> On Fri, Feb 19, 2010 at 7:56 PM, James Bottomley
> <James.Bottomley-l3A5Bk7waGM@public.gmane.org> wrote:
> 
> > Before we get into that, what architecture is this?  There are a few,
> > like arm that don't have architecture support for chaining, so they can
> > never go over 128 segments.
> 
> I am using the desktop PC to access my device. i.e, Intel processor
> with x86 architecture.

OK, so now see what max_hw_sectors_kb says ... if it's still 512 and
you're sure you've got sg_tablesize set to something higher, there's
likely something in the USB stack resetting it ... I suppose it's
possible there's something else in your kernel doing that for the
architecture, but you could rule that out by looking at
max_hw_sectors_kb for either a SCSI or libata device and verifying it's
much higher than 512.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
