From: akpm@osdl.org
Subject: [patch 22/24] drivers/scsi/gdth.h: removal of old scsi code
Date: Mon, 14 Aug 2006 23:09:38 -0700
Message-ID: <200608150609.k7F69chm013273@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:14486 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965189AbWHOGK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:10:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, michal.k.k.piotrowski@gmail.com

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/gdth.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/scsi/gdth.h~drivers-scsi-gdthh-removal-of-old-scsi-code drivers/scsi/gdth.h
--- a/drivers/scsi/gdth.h~drivers-scsi-gdthh-removal-of-old-scsi-code
+++ a/drivers/scsi/gdth.h
@@ -936,18 +936,12 @@ typedef struct {
     gdth_binfo_str      binfo;                  /* controller info */
     gdth_evt_data       dvr;                    /* event structure */
     spinlock_t          smp_lock;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     struct pci_dev      *pdev;
-#endif
     char                oem_name[8];
 #ifdef GDTH_DMA_STATISTICS
     ulong               dma32_cnt, dma64_cnt;   /* statistics: DMA buffer */
 #endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,4,0)
     struct scsi_device         *sdev;
-#else
-    struct scsi_device         sdev;
-#endif
 } gdth_ha_str;
 
 /* structure for scsi_register(), SCSI bus != 0 */
@@ -1029,10 +1023,6 @@ typedef struct {
 
 /* function prototyping */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 int gdth_proc_info(struct Scsi_Host *, char *,char **,off_t,int,int);
-#else
-int gdth_proc_info(char *,char **,off_t,int,int,int);
-#endif
 
 #endif
_
