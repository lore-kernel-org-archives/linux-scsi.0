From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH fix for 3.17 0/1] uas: Add no-report-opcodes quirk
Date: Tue, 16 Sep 2014 18:36:51 +0200
Message-ID: <1410885412-8626-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Claudio Bizzarri <claudio.bizzarri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg, et al,

Another day, another uas quirk. Although you may not see it that way, this
is
actually a good thing :) With the new uas error handling code (which users
are
testing through a stand-alone version of the uas driver), people are now
actually sending me logs with useful error messages instead of complaining
uas crashes their system.

These error logs allow me to figure out the right quirks for various models
(which unfortunately are necessary), and get more uas disk enclosures to
work
properly in uas mode.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
