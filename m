From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: Re: BUG in kernel: Wrong Handling of USB
 =?UTF-8?Q?HDD=E2=80=99s?= in scsiglue(slave_configure) and
 scsi/sd(sd_read_cache_type)
Date: Mon, 03 Oct 2011 14:32:35 -0500
Message-ID: <1317670355.3041.53.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1110031408420.1882-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.1110031408420.1882-100000-IYeN2dnnYyZXsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, Amit Sahrawat <amit.sahrawat83-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-03 at 14:10 -0400, Alan Stern wrote:
> > No. You need to also take into account the RBC
> > device parameters mode page if present. See above.
> 
> All right, suppose neither page is present.  Does it then make sense to 
> assume by default that write caching is enabled?

You're the USB expert ... if we do that, we'll start sending
SYNCHRONIZE_CACHE commands down to a whole slew of devices we didn't
before ... is that going to cause problems with any USB SATLs?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
