From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from
Date: Mon, 21 Jun 2004 20:29:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621182918.GX1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:61831 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266384AbUFUS3Q
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:29:16 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: garloff@suse.de
Cc: linux-scsi@vger.kernel.org


 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 Signed-off-by: Maximilian Attems <janitor@sternwelten.at>


---

 linux-2.6.7-max/drivers/scsi/dc390.h |    7 +------
 1 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/scsi/dc390.h~remove-old-ifdefs-dc390 drivers/scsi/dc390.h
--- linux-2.6.7/drivers/scsi/dc390.h~remove-old-ifdefs-dc390	2004-06-18 09:14:56.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/dc390.h	2004-06-18 09:14:56.000000000 +0200
@@ -13,11 +13,6 @@
 #ifndef DC390_H
 #define DC390_H
 
-#include <linux/version.h>
-#ifndef KERNEL_VERSION
-# define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))
-#endif
-
 #define DC390_BANNER "Tekram DC390/AM53C974"
 #define DC390_VERSION "2.1b 2004-04-13"
 
@@ -26,7 +21,7 @@
  * So long: Use old exception handling :-( */
 #define OLD_EH
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION (2,1,70) || defined (OLD_EH)
+#ifdef OLD_EH
 # define NEW_EH
 #else
 # define NEW_EH use_new_eh_code: 1,

_
