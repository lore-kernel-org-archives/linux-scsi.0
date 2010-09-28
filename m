From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] UAS driver
Date: Mon, 27 Sep 2010 22:56:49 -0700
Message-ID: <20100928055649.GB8922@kroah.com>
References: <20100928050733.GB3799@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100928050733.GB3799-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 28, 2010 at 01:07:34AM -0400, Matthew Wilcox wrote:
> +static struct usb_device_id uas_usb_ids[] = {
> +	{ USB_INTERFACE_INFO(8, 6, 0x50) },
> +	{ USB_INTERFACE_INFO(8, 6, 0x62) },
> +	{ USB_INTERFACE_INFO(8, 6, 0xaa) }, /* A prototype */
> +	{ }

Don't we have the proper #defines in the usb/ch9.h file that you can use
here?  If not, please add them so that we don't have "magic" numbers.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
