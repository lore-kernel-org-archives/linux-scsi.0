From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] sd.c: Make initialisation less verbose
Date: Fri, 9 Oct 2009 10:54:30 -0700
Message-ID: <20091009175430.GB5718@kroah.com>
References: <20090920225348.GB3690@parisc-linux.org>
 <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org>
 <20090924221702.GA7943@parisc-linux.org>
 <20090924222056.GE7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090924222056.GE7943-6jwH94ZQLHl74goWV3ctuw@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <matthew-Ztpu424NOJ8@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 24, 2009 at 04:20:56PM -0600, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> 
> Introduce a new function, sd_print_info() to print the information we
> normally want to display to the user on revalidation.
> 
> Move the capacity display from sd_read_capacity() to sd_print_info().
> Move the write protect display from sd_read_write_protect_flag() to
> sd_print_info().
> Delete the printk reporting Mode Sense as it is not generally useful.
> 
> Move the display of 'Removable' to the same line as reporting the Write
> Protect status.
> 
> Only print the line about write cache once.

No signed off by line?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
