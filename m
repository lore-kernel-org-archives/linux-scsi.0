From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 2 Oct 2014 06:27:59 -0700
Message-ID: <20141002132759.GA26965@kroah.com>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
 <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
 <20141002112627.GC17628@infradead.org>
 <542D467E.2020400@redhat.com>
 <20141002130654.GA17051@infradead.org>
 <542D4E58.5000809@redhat.com>
 <20141002131259.GA930@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141002131259.GA930-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 02, 2014 at 06:12:59AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 02, 2014 at 03:08:40PM +0200, Hans de Goede wrote:
> > Yes, although that likely would need to go through stable, without
> > going into 3.18 .
> > 
> > Greg, is this ok with you and how do I get a patch in stable which
> > is not in upstream (because upstream will get a better fix) ?
> 
> This is a trivial one liner and 3.17 isn't released yet, so can you just
> send it to Linus now?

Let's just wait for these patches to get into 3.18-rc1, and then, Hans,
you can send me a patch just for 3.17-stable with a note saying why it
is different from what is in Linus's tree.

Or send me that patch now and I can queue it up at the proper time.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
