From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] uas: Make uas work with blk-mq
Date: Sun, 5 Oct 2014 02:10:15 -0700
Message-ID: <20141005091015.GA29855@infradead.org>
References: <1412330937-22630-1-git-send-email-hdegoede@redhat.com>
 <1412330937-22630-2-git-send-email-hdegoede@redhat.com>
 <20141003214712.GA3579@kroah.com>
 <542FB590.4030902@redhat.com>
 <1412433981.21548.6.camel@jarvis.lan>
 <543109F8.3030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <543109F8.3030303-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Oct 05, 2014 at 11:06:00AM +0200, Hans de Goede wrote:
> This patch sits on top of a lot of other uas fixes which are already
> in usb-next, so this needs to go in through usb-next.

What is the actual conflict?  If it's just your revert of the
disable_blk_mq flag you might want to skip that for this pull request
and send it on after both scsi and usb trees make it to Linus.

If there's more conflict around the host template you could cherry pick
my patch for your tree.
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
