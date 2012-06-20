From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 2/7] Revert "usb/uas: one only one status URB/host on
 stream-less connection"
Date: Wed, 20 Jun 2012 16:56:44 -0700
Message-ID: <20120620235644.GD31520@kroah.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
 <1340092494-18876-3-git-send-email-kraxel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1340092494-18876-3-git-send-email-kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 19, 2012 at 09:54:49AM +0200, Gerd Hoffmann wrote:
> This reverts commit ceb3f91fd53c9fbd7b292fc2754ba4efffeeeedb.
> 
> IMO the real bug is assigning status urbs to scsi requests.  First there
> is no such link in the non-stream case.  Also there isn't nessesarely a
> scsi request in the first place, for example when submitting task
> management requests.
> 
> This patch just papers over the real bug and introduces different status
> urb handling in the stream/non-stream case for no good reason.
> 
> Signed-off-by: Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/usb/storage/uas.c |   70 ++++++--------------------------------------
>  1 files changed, 10 insertions(+), 60 deletions(-)

Same here, should this also be reverted in 3.4-stable?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
