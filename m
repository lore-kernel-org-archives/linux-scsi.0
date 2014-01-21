From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: [PATCH 0/2] target refcounting infrastructure fixes for usb
Date: Tue, 21 Jan 2014 06:58:39 -0800
Message-ID: <1390316319.2182.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

After about 3 iterations as an RFC, I'm elevating this to a patch.  If
it works, I'll try for this merge window with a delayed backport to
stable (after the next kernel release to make sure no bugs got
introduced).

This set should fix our target problems with USB by making the target
visibility properly reference counted.

James Bottomley (2):
  [SCSI] fix our current target reap infrastructure.
  [SCSI] dual scan thread bug fix

 drivers/scsi/scsi_scan.c   | 112 ++++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_sysfs.c  |  20 +++++---
 include/scsi/scsi_device.h |   3 +-
 3 files changed, 86 insertions(+), 49 deletions(-)

-- 
1.8.4.3



--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
