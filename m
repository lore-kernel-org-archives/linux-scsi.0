From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] uas: Make uas work with blk-mq
Date: Thu, 02 Oct 2014 14:35:10 +0200
Message-ID: <542D467E.2020400@redhat.com>
References: <1412244280-15111-1-git-send-email-hdegoede@redhat.com> <1412244280-15111-2-git-send-email-hdegoede@redhat.com> <20141002112627.GC17628@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141002112627.GC17628-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

On 10/02/2014 01:26 PM, Christoph Hellwig wrote:
> Looks fine to me (and actually removes code..)
> 
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> 
> It's fairly late in 3.17 to get something like this in, but would you
> consider Ccing it to stable so we can get it into the first 3.17 stable
> release?

This patch sits on top of a whole bunch of uas cleanups / fixes which
are going into 3.18, and which are to big of a change to backport.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
