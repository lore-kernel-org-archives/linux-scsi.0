From: Tom Yan <tom.ty89-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [uas/scsi] untagged commands?
Date: Tue, 24 May 2016 16:18:19 +0800
Message-ID: <CAGnHSE=RB1_777Mnj8enxDPmga0p7QgZkyFwg9je5FQmzO=qDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

In this commit:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/usb/storage/uas.c?id=198de51dbc3454d95b015ca0a055b673f85f01bb

There is the following comment:
> 1 tag is reserved for untagged commands

So my question is, what exactly are "untagged commands"?

If we need to reserve (only) 1 tag for them, does that mean "untagged
commands" will never be queued? (I mean, not counting the "tagged
commands"; so in the queue there will always be at most 1 "untagged
command" and a certain number, or none, of tagged commands?)

Also, what determines whether a command is tagged or not? Is it merely
depending on how a program (or maybe the kernel) issue the commands?
Or can a device (or maybe the driver) require specific SCSI command(s)
to always be issued untagged?

In any case, is there a way (e.g. a debug option/level of the sd or
the uas driver, etc.) to show/log whether the issued commands are
tagged or untagged?
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
