From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH fixes for 3.17 0/2] uas: Disable uas on ASM1051 devices
Date: Tue,  9 Sep 2014 16:59:58 +0200
Message-ID: <1410274800-11578-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

I've received a number of bug-reports from users related to uas on ASM1051
chipset using devices. After some searching around I've managed to get myself
an ASM1051 device.

As a result I've spend the last 4 days trying to get the ASM1051 chipset to
work. After some initial success which makes it work with most disks I've
laying around (patch 1), I hit problems with one disk where it just would
not work.

To makes matters worse the ASM1051 chipset shares its usb-id with older
versions of the ASM1053, which works fine with all disks.

So I've come up with a patch which disables uas on all ASM1051 devices and on
some ASM1053 devices. Both the need to blacklist and the actual blacklisting
code are less then satisfactory, esp. after 4 days of work. But this is the
best I can come up with :|

It seems that older uas-bridge chips and xhci controllers streams support are
suffering from quite a few hw bugs, and that blacklisting is the best we can
do.

Regards,

Hans
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
