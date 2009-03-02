From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Set manage_start_stop for some USB storage devices by
	default
Date: Mon, 2 Mar 2009 13:31:12 -0800
Message-ID: <20090302213112.GA30677@kroah.com>
References: <20090302195238.GM3741@vespa.holoscopio.com> <Pine.LNX.4.44L0.0903021452570.12723-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903021452570.12723-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo-DmMZpsCg3uxeGPcbtGPokg@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Mar 02, 2009 at 02:57:03PM -0500, Alan Stern wrote:
> On Mon, 2 Mar 2009, Thadeu Lima de Souza Cascardo wrote:
> > > Also, this patch won't apply to the current development tree, because
> > > there have been several changes to usb-storage's recently.  In
> > > particular there is new code allowing quirk flags to be set by a module
> > > parameter, and your new flag (if it is accepted) should be added to
> > > this mechanism.
> > 
> > Also expected. But I didn't know about the new changes in the quirk
> > flags code. Which tree should I refer to regarding usb-storage or USB,
> > besides next and rc trees?
> 
> http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
> 
> I tend to use the gregkh-all-*.patch files.  However, I think 
> everything in there also goes into -next.

Yes, it all is in the linux-next releases, you can use those if it's
easier than using my trees.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
