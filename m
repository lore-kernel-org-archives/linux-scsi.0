From: Stefan Richter <stefanr-MtYdepGKPcBMYopoZt5u/LNAH6kLmebB@public.gmane.org>
Subject: Re: 2.6.39-rc3: usb-storage hotplug kref corruption/ list
 corruption
Date: Fri, 22 Apr 2011 11:29:27 +0200
Message-ID: <20110422112927.0fd30b6d@stein>
References: <20110414204910.625a1c51@stein>
	<20110414192941.GA17591@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110414192941.GA17591-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Apr 14 Greg KH wrote:
> On Thu, Apr 14, 2011 at 08:49:10PM +0200, Stefan Richter wrote:
> > Also, I am noticing now that there was already a lockdep report from when
> > the EHCI driver was loaded.
> 
> We have a patch for that which will go to Linus later this week, so that
> shouldn't be an issue here.

Thanks Greg,
I think I will give 2.6.39 another try when -rc5 is out...  The SCSI device
kref underflow on the other hand has been confirmed by another reporter,
this time on 2.6.39-rc4:
https://bugzilla.kernel.org/show_bug.cgi?id=33802
-- 
Stefan Richter
-=====-==-== -=-- =-==-
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
