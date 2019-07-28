From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] scsi: raid_class: add include guard to raid_class.h
Date: Mon, 29 Jul 2019 01:47:06 +0900
Message-ID: <20190728164706.16558-1-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Allison Randal <allison@lohutok.net>, Armijn Hemel <armijn@tjaldur.nl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/linux/raid_class.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
index 5cdfcb873a8f..b62e42d8bb17 100644
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -4,6 +4,10 @@
  *
  * Copyright (c) 2005 - James Bottomley <James.Bottomley@steeleye.com>
  */
+
+#ifndef _LINUX_RAID_CLASS_H
+#define _LINUX_RAID_CLASS_H
+
 #include <linux/transport_class.h>
 
 struct raid_template {
@@ -81,3 +85,4 @@ void raid_class_release(struct raid_template *);
 int __must_check raid_component_add(struct raid_template *, struct device *,
 				    struct device *);
 
+#endif /* _LINUX_RAID_CLASS_H */
-- 
2.17.1
