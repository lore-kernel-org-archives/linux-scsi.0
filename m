From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 16:21:53 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0901281620130.2231-100000@iolanthe.rowland.org>
References: <20090128141035.3a26ea60.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090128141035.3a26ea60.zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pete Zaitcev <zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009, Pete Zaitcev wrote:

> > > >From the middle of the log (after the partition table has been read):
> > > 
> > > > [   32.056855] usb-storage: queuecommand called
> > > > [   32.056886] usb-storage: *** thread awakened.
> > > > [   32.056888] usb-storage: Command START_STOP (6 bytes)
> 
> Middle huh. I _really_ wish people stopped editing their logs. How
> am I supposed to determine if this was sent immediately after open
> (e.g. your HAL is screwing with you), or it happened after a time
> of inactivity?

Don't blame this on Dirk; he was just quoting something I had sent, in 
which I extracted part of his log.  The entire log is earlier in this 
thread.  The timestamp shows that the START-STOP UNIT command was sent 
less than 0.5 seconds after usb-storage first probed the device.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
