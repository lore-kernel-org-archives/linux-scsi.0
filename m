From: worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org (Dale R. Worley)
Subject: Large disk drives
Date: Mon, 3 Nov 2014 16:06:22 -0500
Message-ID: <201411032106.sA3L6MqU026397@hobgoblin.ariadne.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Was there any resolution as to how large disk drives would be handled
if their interface did not support the "capacity" request that would
tell how large they were?

Or as an alternative, is there any way to avoid buying USB-SCSI
interfaces that do not support the large-capacity request?
Unfortunately, such devices work OK with Windows (since Windows trusts
what the partition table says), you can't just say to the salesperson
"It has to work on drives over 3 TB."

Dale
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
