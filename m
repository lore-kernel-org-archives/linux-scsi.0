From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 11072] New: scsi-layer crash after usb storage
 device unplug
Date: Sat, 12 Jul 2008 15:50:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0807121548190.17776-100000@netrider.rowland.org>
References: <20080712060525.07b718da.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20080712060525.07b718da.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 12 Jul 2008, Andrew Morton wrote:

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Sat, 12 Jul 2008 01:50:37 -0700 (PDT) bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=11072
> > 
> >            Summary: scsi-layer crash after usb storage device unplug

> > Latest working kernel version: no idea, never saw this problem before with the
> > same device, but the memory card is new
> > Earliest failing kernel version: no idea either, current kernel is
> > 2.6.26-rc9-wl-12766-ga0b2a63-dirty
> > Distribution: debian/unstable
> > Hardware Environment: powerbook 5,6
> > Software Environment:
> > Problem Description: SDHC card in USB reader wasn't responding, so I unplugged
> > and got a null pointer deref

This looks like a problem reported earlier and fixed by this patch:

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/usb-storage-revert-dma-alignment-change-for-wireless-usb.patch

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
