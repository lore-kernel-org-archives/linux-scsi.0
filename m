From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 00/24] uas: rewrite error handling for robustness + misc cleanups
Date: Sat, 13 Sep 2014 12:26:27 +0200
Message-ID: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg, et al,

Here is v2 of my uas error handling rewrite + cleanups series.

Note this has been rebased on top of the

"[PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and ATA_16 commands"

patch which I've just send, so if that does not make 3.17, you should still
apply that one first to avoid conflicts.

Changes since v1:
-Rebased on top of:
 "uas: Add a quirk for rejecting ATA_12 and ATA_16 commands"
-"uas: zap_pending: data urbs should have completed at this time":
 Modified WARN_ON check to not have side effects
-Added 3 new patches:
 "uas: Cleanup uas_log_cmd_state usage"
 "uas: Log error codes when logging errors"
 "uas: Add response iu handling"

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
