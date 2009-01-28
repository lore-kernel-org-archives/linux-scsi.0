From: Pete Zaitcev <zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 14:27:29 -0700
Message-ID: <20090128142729.6e047785.zaitcev@redhat.com>
References: <20090127122641.1564fc46@infradead.org>
	<Pine.LNX.4.44L0.0901271548370.2286-100000@iolanthe.rowland.org>
	<20090127200607.369a1693@infradead.org>
	<20090128141035.3a26ea60.zaitcev@redhat.com>
	<20090128132228.3f1e2f8a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090128132228.3f1e2f8a-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Dharm <mdharm-usb-JGfshJpz5UybPZpvUQj5UqxOck334EZe@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 13:22:28 -0800, Dirk Hohndel <hohndel-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> > > On a 64bit 2.6.29-rc2 system (and a few earlier kernels that I have
> > > tried) I can no longer use USB sticks.
> > 
> > So how do you know that you "no longer" can use USB sticks if you
> > did not find a kernel where it worked? It's either one or the other.

> I know that I had it working when I installed F10. It doesn't work
> right now, but there have been lots of updates to F10 since.

Thanks, that's useful. I guess my idea about ->allow_restart cannot
be relevant then, that code existed for a long time.

> http://kerneltrap.org/mailarchive/linux-usb/2009/1/27/4830624

Got it, thanks.

I also have stock F10 boxes here to test.

-- Pete
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
