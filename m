From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 3/9] drivers/scsi/gdth.h Removal of old scsi code
Date: Sat, 12 Aug 2006 23:02:37 +0200
Message-ID: <44DE41ED.3090607@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422693AbWHLVCG@vger.kernel.org>
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Achim Leubner <achim_leubner@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/gdth.h linux-work/drivers/scsi/gdth.h
--- linux-work-clean/drivers/scsi/gdth.h	2006-08-12 01:51:16.000000000 +0200
+++ linux-work/drivers/scsi/gdth.h	2006-08-12 20:49:38.000000000 +0200
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
