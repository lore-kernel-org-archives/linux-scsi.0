From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: JMS56x not working reliably with uas driver
Date: Tue, 27 Dec 2016 10:20:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1612271015100.21478-100000@netrider.rowland.org>
References: <1482849255.1731.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482849255.1731.1.camel-IBi9RG/b67k@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: George Cherian <gcherian-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 27 Dec 2016, Oliver Neukum wrote:

> On Thu, 2016-12-22 at 17:44 -0500, Alan Stern wrote:
> > I don't see how this patch fixes anything.  Unless I'm mistaken, it
> > just avoids the problem by preventing the system from issuing the
> > command that provokes the error, rather than really fixing the
> > underlying error.
> 
> Please clarify. If a reset leads to a disconnect, isn't that
> exactly what we want?

I didn't express myself clearly enough.  Yes, if a reset leads to a 
disconnect then avoiding the reset will avoid problems.

But the _real_ error here is that xhci-hcd says "ERROR Transfer event
for disabled endpoint or incorrect stream ring" when the disconnect 
occurs during reset.  That shouldn't happen, no matter what quirks the 
device has.  It indicates a bug either in uas or in xhci-hcd.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
