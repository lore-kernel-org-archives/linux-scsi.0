From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.39-rc3: usb-storage hotplug kref corruption/ list corruption
Date: Thu, 14 Apr 2011 12:29:41 -0700
Message-ID: <20110414192941.GA17591@kroah.com>
References: <20110414204910.625a1c51@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110414204910.625a1c51@stein>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2011 at 08:49:10PM +0200, Stefan Richter wrote:
> Also, I am noticing now that there was already a lockdep report from when
> the EHCI driver was loaded.

We have a patch for that which will go to Linus later this week, so that
shouldn't be an issue here.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
