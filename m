From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Large disk drives
Date: Tue, 4 Nov 2014 11:14:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411041112010.966-100000@iolanthe.rowland.org>
References: <1415087562.2351.3.camel@jarvis.mobile.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415087562.2351.3.camel-7O4RPy5TklLPRNG96csxHf8+0UxHXcjY@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Nov 2014, James Bottomley wrote:

> On Mon, 2014-11-03 at 16:06 -0500, Dale R. Worley wrote:
> > Was there any resolution as to how large disk drives would be handled
> > if their interface did not support the "capacity" request that would
> > tell how large they were?
> 
> Realistically no ... unless someone comes up with a reliable heuristic
> to give us the size.

I posted a patch to allow the user to override the reported capacity:

	http://marc.info/?l=linux-scsi&m=140993840113445&w=2

Nobody responded to it.

> > Unfortunately, such devices work OK with Windows (since Windows trusts
> > what the partition table says), you can't just say to the salesperson
> > "It has to work on drives over 3 TB."
> 
> This is a stopgap: your 3TB drive can be guessed as the 16 bit capacity
> plus 2TB, but the same won't happen for a 5TB device.  Believing the
> partition table gives us a chicken and egg problem because something
> still has to get the partition table on to the device.
> 
> I don't think "don't buy something that doesn't work" is a hugely
> unreasonable response to this.

The problem is knowing beforehand whether it will work.  Once you buy 
the device and can test it, returning it is annoying and time-consuming 
at best.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
