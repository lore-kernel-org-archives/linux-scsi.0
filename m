From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
Subject: Re: Large disk drives
Date: Wed, 5 Nov 2014 10:51:17 -0500
Message-ID: <201411051551.sA5FpHBS002762@hobgoblin.ariadne.com>
References: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <Pine.LNX.4.44L0.1411041112010.966-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
	(stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org)
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Replying to two messages at once:

> Date: Tue, 4 Nov 2014 11:14:39 -0500 (EST)
> From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
>         <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> 
> On Tue, 4 Nov 2014, James Bottomley wrote:
> 
> > On Mon, 2014-11-03 at 16:06 -0500, Dale R. Worley wrote:
> > > Was there any resolution as to how large disk drives would be handled
> > > if their interface did not support the "capacity" request that would
> > > tell how large they were?
> > 
> > Realistically no ... unless someone comes up with a reliable heuristic
> > to give us the size.

I can understand why the linux-scsi project would not want to take up
what is really a hack to work around a hardware deficiency.

> I posted a patch to allow the user to override the reported capacity:
> 
> 	http://marc.info/?l=linux-scsi&m=140993840113445&w=2
> 
> Nobody responded to it.
> 
> > > Unfortunately, such devices work OK with Windows (since Windows trusts
> > > what the partition table says), you can't just say to the salesperson
> > > "It has to work on drives over 3 TB."
> > 
> > This is a stopgap: your 3TB drive can be guessed as the 16 bit capacity
> > plus 2TB, but the same won't happen for a 5TB device.  Believing the
> > partition table gives us a chicken and egg problem because something
> > still has to get the partition table on to the device.
> > 
> > I don't think "don't buy something that doesn't work" is a hugely
> > unreasonable response to this.
> 
> The problem is knowing beforehand whether it will work.  Once you buy 
> the device and can test it, returning it is annoying and time-consuming 
> at best.

Or as I would phrase it, How do you turn "Don't buy something that
doesn't work!" into an algorithm?  That is:  I'm standing in
MicroCenter, holding a box in my hand that contains a USB-to-SCSI
adapter.  How do I determine whether or not it supports large disks?
The problem being that it *works with Windows*, so I can't just ask
the friendly salesperson, Does this work with 3 terabyte disks?

In my case, the Diablotek device works, while the Kingwin EZ-Connect
does not, despite being labeled in essentially the same way.  (Neither
says that Linux is supported.)

I admit that my problem may be my deficiency in dealing with the
retail situation, as I'm a much better software engineer than shopper.

Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
