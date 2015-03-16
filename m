From: Vladimir Romanov <blueboar2@gmail.com>
Subject: Patch for /drivers/scsi/fnic/vnic_dev.c file
Date: Mon, 16 Mar 2015 09:22:10 +0500
Message-ID: <CAKx5OMZJUz+amr75A0v-oG6nycnasBqXNzNE9zHyUowJN-xatA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:36707 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbbCPEWN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2015 00:22:13 -0400
Received: by yhjf44 with SMTP id f44so13622906yhj.3
        for <linux-scsi@vger.kernel.org>; Sun, 15 Mar 2015 21:22:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I am programmer from Kurgan, Russia, and this is my first attempt to
send some patch to linux kernel. Please review it, and if it is
acceptable, please commit it.

If there is some error, please, tell me, how i can solve it.

--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -500,9 +500,8 @@
     err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
     if (err)
         printk(KERN_ERR
-            "Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-            addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-            err);
+            "Can't add addr [%pM], %d\n",
+            addr, err);
 }

 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
@@ -518,9 +517,8 @@
     err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
     if (err)
         printk(KERN_ERR
-            "Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
-            addr[0], addr[1], addr[2], addr[3], addr[4], addr[5],
-            err);
+            "Can't del addr [%pM], %d\n",
+            addr, err);
 }

 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
