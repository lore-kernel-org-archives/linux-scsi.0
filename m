From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 02 Oct 2014 09:25:50 -0400
Message-ID: <1412256350.6343.18.camel@jarvis>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com>
	 <1412244280-15111-2-git-send-email-hdegoede@redhat.com>
	 <20141002112627.GC17628@infradead.org> <542D467E.2020400@redhat.com>
	 <20141002130654.GA17051@infradead.org> <542D4E58.5000809@redhat.com>
	 <20141002131259.GA930@infradead.org> <542D5096.9010503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <542D5096.9010503-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-10-02 at 15:18 +0200, Hans de Goede wrote:
> Hi,
> 
> On 10/02/2014 03:12 PM, Christoph Hellwig wrote:
> > On Thu, Oct 02, 2014 at 03:08:40PM +0200, Hans de Goede wrote:
> >> Yes, although that likely would need to go through stable, without
> >> going into 3.18 .
> >>
> >> Greg, is this ok with you and how do I get a patch in stable which
> >> is not in upstream (because upstream will get a better fix) ?
> > 
> > This is a trivial one liner and 3.17 isn't released yet, so can you just
> > send it to Linus now?
> 
> I don't think it is that urgent, given that block-mq is disabled by default
> in 3.17 AFAIK. But feel free to send such a patch directly to Linus with my:
> 
> Acked-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Added, if that gets in, I guess I then need to do a v2 of the patch
> from $subject, reverting it.

OK, so 3.17 should be on sunday giving three days or so to sort this
out.  If you're happy with blk-mq being disabled so the bug never
triggers unless the user activates it, doing nothing is my preferred
outcome ... but that also means no need to backport to stable.  

If you want a it fixed in 3.17, then we need a patch from you now.
Ultimately you have to judge the necessity for us, since it's your
driver.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
