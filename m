From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH] scsi: ch: add include guard to chio.h
Date: Mon, 29 Jul 2019 01:46:43 +0900
Message-ID: <20190728164643.16335-1-yamada.masahiro@socionext.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/uapi/linux/chio.h | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/chio.h b/include/uapi/linux/chio.h
index 689fc93fafda..e1cad4c319ee 100644
--- a/include/uapi/linux/chio.h
+++ b/include/uapi/linux/chio.h
@@ -3,6 +3,9 @@
  * ioctl interface for the scsi media changer driver
  */
 
+#ifndef _UAPI_LINUX_CHIO_H
+#define _UAPI_LINUX_CHIO_H
+
 /* changer element types */
 #define CHET_MT   0	/* media transport element (robot) */
 #define CHET_ST   1	/* storage element (media slots) */
@@ -160,10 +163,4 @@ struct changer_set_voltag {
 #define CHIOSVOLTAG    _IOW('c',18,struct changer_set_voltag)
 #define CHIOGVPARAMS   _IOR('c',19,struct changer_vendor_params)
 
-/* ---------------------------------------------------------------------- */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
+#endif /* _UAPI_LINUX_CHIO_H */
-- 
2.17.1
