From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [Bugme-new] [Bug 13420] New: NULL pointer dereference after
	hard-resetting a usb-connected iPod
Date: Mon, 1 Jun 2009 22:59:12 -0700
Message-ID: <20090602055912.GA28470@kroah.com>
References: <bug-13420-10286@http.bugzilla.kernel.org/> <20090601214801.0d59154a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090601214801.0d59154a.akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, bugme-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org, dariush-0tmriiNh0bMb1SvskN2V4Q@public.gmane.org, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 01, 2009 at 09:48:01PM -0700, Andrew Morton wrote:
> Kay: if you have time: driver do this rather a lot and it would be good
> if we could bullet-proof the core a bit more to handle these bugs more
> gracefully.

This should be fixed in 2.6.30-rc8 by making the driver core more robust
in this type of problem.  It will still spit out a big tracedump if it
happens, so that will be good to see what is going on.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
