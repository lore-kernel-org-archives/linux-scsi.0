From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] aic7xxx: update shipped files
Date: Fri, 25 Apr 2008 15:03:05 +0200
Message-ID: <4811D689.2020602@suse.de>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250436.01295.vda.linux@googlemail.com> <200804250441.43480.vda.linux@googlemail.com> <200804250444.26373.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080808010001050708020702"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:47517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383AbYDYNDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2008 09:03:08 -0400
In-Reply-To: <200804250444.26373.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

This is a multi-part message in MIME format.
--------------080808010001050708020702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Hi Denys,

Denys Vlasenko wrote:
> After previous patch shipped files are out of sync.
> 
> This patch updates them.
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
See my previous mail.
No, don't do it like this.

I've attached the updated files based on my modified patch.

James, please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)

--------------080808010001050708020702
Content-Type: text/plain;
 name="aic7xxx-update-shipped-files"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic7xxx-update-shipped-files"

commit 883bcfc7b6023df01499f5811dcb39175120e7d3
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Apr 25 14:45:01 2008 +0200

    aic7xxx: Update _shipped files
    
    Update the precompiled sequencer code to match the latest
    aicasm changes.
    
    Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped b/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
index 2068e00..c21ceab 100644
--- a/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped
@@ -48,13 +48,6 @@ ahd_reg_print_t ahd_error_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrerr_print;
-#else
-#define ahd_clrerr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRERR", 0x04, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_hcntrl_print;
 #else
 #define ahd_hcntrl_print(regvalue, cur_col, wrap) \
@@ -167,13 +160,6 @@ ahd_reg_print_t ahd_sg_cache_shadow_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_arbctl_print;
-#else
-#define ahd_arbctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ARBCTL", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sg_cache_pre_print;
 #else
 #define ahd_sg_cache_pre_print(regvalue, cur_col, wrap) \
@@ -188,20 +174,6 @@ ahd_reg_print_t ahd_lqin_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_typeptr_print;
-#else
-#define ahd_typeptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TYPEPTR", 0x20, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_tagptr_print;
-#else
-#define ahd_tagptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TAGPTR", 0x21, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lunptr_print;
 #else
 #define ahd_lunptr_print(regvalue, cur_col, wrap) \
@@ -209,20 +181,6 @@ ahd_reg_print_t ahd_lunptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_datalenptr_print;
-#else
-#define ahd_datalenptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DATALENPTR", 0x23, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_statlenptr_print;
-#else
-#define ahd_statlenptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "STATLENPTR", 0x24, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_cmdlenptr_print;
 #else
 #define ahd_cmdlenptr_print(regvalue, cur_col, wrap) \
@@ -258,13 +216,6 @@ ahd_reg_print_t ahd_qnextptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_idptr_print;
-#else
-#define ahd_idptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "IDPTR", 0x2a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_abrtbyteptr_print;
 #else
 #define ahd_abrtbyteptr_print(regvalue, cur_col, wrap) \
@@ -279,27 +230,6 @@ ahd_reg_print_t ahd_abrtbitptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_maxcmdbytes_print;
-#else
-#define ahd_maxcmdbytes_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MAXCMDBYTES", 0x2d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_maxcmd2rcv_print;
-#else
-#define ahd_maxcmd2rcv_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MAXCMD2RCV", 0x2e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_shortthresh_print;
-#else
-#define ahd_shortthresh_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SHORTTHRESH", 0x2f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lunlen_print;
 #else
 #define ahd_lunlen_print(regvalue, cur_col, wrap) \
@@ -328,41 +258,6 @@ ahd_reg_print_t ahd_maxcmdcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqrsvd01_print;
-#else
-#define ahd_lqrsvd01_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQRSVD01", 0x34, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqrsvd16_print;
-#else
-#define ahd_lqrsvd16_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQRSVD16", 0x35, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqrsvd17_print;
-#else
-#define ahd_lqrsvd17_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQRSVD17", 0x36, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmdrsvd0_print;
-#else
-#define ahd_cmdrsvd0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMDRSVD0", 0x37, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqctl0_print;
-#else
-#define ahd_lqctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQCTL0", 0x38, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqctl1_print;
 #else
 #define ahd_lqctl1_print(regvalue, cur_col, wrap) \
@@ -370,13 +265,6 @@ ahd_reg_print_t ahd_lqctl1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsbist0_print;
-#else
-#define ahd_scsbist0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSBIST0", 0x39, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqctl2_print;
 #else
 #define ahd_lqctl2_print(regvalue, cur_col, wrap) \
@@ -384,13 +272,6 @@ ahd_reg_print_t ahd_lqctl2_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsbist1_print;
-#else
-#define ahd_scsbist1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSBIST1", 0x3a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsiseq0_print;
 #else
 #define ahd_scsiseq0_print(regvalue, cur_col, wrap) \
@@ -412,20 +293,6 @@ ahd_reg_print_t ahd_sxfrctl0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dlcount_print;
-#else
-#define ahd_dlcount_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DLCOUNT", 0x3c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_businitid_print;
-#else
-#define ahd_businitid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BUSINITID", 0x3c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sxfrctl1_print;
 #else
 #define ahd_sxfrctl1_print(regvalue, cur_col, wrap) \
@@ -433,20 +300,6 @@ ahd_reg_print_t ahd_sxfrctl1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_bustargid_print;
-#else
-#define ahd_bustargid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BUSTARGID", 0x3e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sxfrctl2_print;
-#else
-#define ahd_sxfrctl2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SXFRCTL2", 0x3e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dffstat_print;
 #else
 #define ahd_dffstat_print(regvalue, cur_col, wrap) \
@@ -454,17 +307,17 @@ ahd_reg_print_t ahd_dffstat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsisigo_print;
+ahd_reg_print_t ahd_multargid_print;
 #else
-#define ahd_scsisigo_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISIGO", 0x40, regvalue, cur_col, wrap)
+#define ahd_multargid_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "MULTARGID", 0x40, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_multargid_print;
+ahd_reg_print_t ahd_scsisigo_print;
 #else
-#define ahd_multargid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MULTARGID", 0x40, regvalue, cur_col, wrap)
+#define ahd_scsisigo_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCSISIGO", 0x40, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -482,13 +335,6 @@ ahd_reg_print_t ahd_scsiphase_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsidat0_img_print;
-#else
-#define ahd_scsidat0_img_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIDAT0_IMG", 0x43, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsidat_print;
 #else
 #define ahd_scsidat_print(regvalue, cur_col, wrap) \
@@ -531,13 +377,6 @@ ahd_reg_print_t ahd_sblkctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint0_print;
-#else
-#define ahd_clrsint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT0", 0x4b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sstat0_print;
 #else
 #define ahd_sstat0_print(regvalue, cur_col, wrap) \
@@ -552,10 +391,10 @@ ahd_reg_print_t ahd_simode0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint1_print;
+ahd_reg_print_t ahd_clrsint0_print;
 #else
-#define ahd_clrsint1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT1", 0x4c, regvalue, cur_col, wrap)
+#define ahd_clrsint0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CLRSINT0", 0x4b, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -566,17 +405,17 @@ ahd_reg_print_t ahd_sstat1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sstat2_print;
+ahd_reg_print_t ahd_clrsint1_print;
 #else
-#define ahd_sstat2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
+#define ahd_clrsint1_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CLRSINT1", 0x4c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode2_print;
+ahd_reg_print_t ahd_sstat2_print;
 #else
-#define ahd_simode2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE2", 0x4d, regvalue, cur_col, wrap)
+#define ahd_sstat2_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -622,17 +461,17 @@ ahd_reg_print_t ahd_lqistat0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqiint0_print;
+ahd_reg_print_t ahd_lqimode0_print;
 #else
-#define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQIINT0", 0x50, regvalue, cur_col, wrap)
+#define ahd_lqimode0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "LQIMODE0", 0x50, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqimode0_print;
+ahd_reg_print_t ahd_clrlqiint0_print;
 #else
-#define ahd_lqimode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQIMODE0", 0x50, regvalue, cur_col, wrap)
+#define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CLRLQIINT0", 0x50, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -790,13 +629,6 @@ ahd_reg_print_t ahd_seqintsrc_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_currscb_print;
-#else
-#define ahd_currscb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CURRSCB", 0x5c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqimode_print;
 #else
 #define ahd_seqimode_print(regvalue, cur_col, wrap) \
@@ -804,24 +636,17 @@ ahd_reg_print_t ahd_seqimode_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mdffstat_print;
-#else
-#define ahd_mdffstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_crccontrol_print;
+ahd_reg_print_t ahd_currscb_print;
 #else
-#define ahd_crccontrol_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CRCCONTROL", 0x5d, regvalue, cur_col, wrap)
+#define ahd_currscb_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "CURRSCB", 0x5c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfftag_print;
+ahd_reg_print_t ahd_mdffstat_print;
 #else
-#define ahd_dfftag_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFTAG", 0x5e, regvalue, cur_col, wrap)
+#define ahd_mdffstat_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -832,20 +657,6 @@ ahd_reg_print_t ahd_lastscb_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsitest_print;
-#else
-#define ahd_scsitest_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSITEST", 0x5e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_iopdnctl_print;
-#else
-#define ahd_iopdnctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "IOPDNCTL", 0x5f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_shaddr_print;
 #else
 #define ahd_shaddr_print(regvalue, cur_col, wrap) \
@@ -860,13 +671,6 @@ ahd_reg_print_t ahd_negoaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dgrpcrci_print;
-#else
-#define ahd_dgrpcrci_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DGRPCRCI", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_negperiod_print;
 #else
 #define ahd_negperiod_print(regvalue, cur_col, wrap) \
@@ -874,13 +678,6 @@ ahd_reg_print_t ahd_negperiod_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_packcrci_print;
-#else
-#define ahd_packcrci_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PACKCRCI", 0x62, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_negoffset_print;
 #else
 #define ahd_negoffset_print(regvalue, cur_col, wrap) \
@@ -930,13 +727,6 @@ ahd_reg_print_t ahd_iownid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll960ctl0_print;
-#else
-#define ahd_pll960ctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL960CTL0", 0x68, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_shcnt_print;
 #else
 #define ahd_shcnt_print(regvalue, cur_col, wrap) \
@@ -951,27 +741,6 @@ ahd_reg_print_t ahd_townid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll960ctl1_print;
-#else
-#define ahd_pll960ctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL960CTL1", 0x69, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll960cnt0_print;
-#else
-#define ahd_pll960cnt0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL960CNT0", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_xsig_print;
-#else
-#define ahd_xsig_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "XSIG", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seloid_print;
 #else
 #define ahd_seloid_print(regvalue, cur_col, wrap) \
@@ -979,41 +748,6 @@ ahd_reg_print_t ahd_seloid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll400ctl0_print;
-#else
-#define ahd_pll400ctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL400CTL0", 0x6c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_fairness_print;
-#else
-#define ahd_fairness_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FAIRNESS", 0x6c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll400ctl1_print;
-#else
-#define ahd_pll400ctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL400CTL1", 0x6d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_unfairness_print;
-#else
-#define ahd_unfairness_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "UNFAIRNESS", 0x6e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll400cnt0_print;
-#else
-#define ahd_pll400cnt0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL400CNT0", 0x6e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_haddr_print;
 #else
 #define ahd_haddr_print(regvalue, cur_col, wrap) \
@@ -1021,27 +755,6 @@ ahd_reg_print_t ahd_haddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_plldelay_print;
-#else
-#define ahd_plldelay_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLLDELAY", 0x70, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hodmaadr_print;
-#else
-#define ahd_hodmaadr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HODMAADR", 0x70, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hodmacnt_print;
-#else
-#define ahd_hodmacnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HODMACNT", 0x78, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_hcnt_print;
 #else
 #define ahd_hcnt_print(regvalue, cur_col, wrap) \
@@ -1049,10 +762,10 @@ ahd_reg_print_t ahd_hcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hodmaen_print;
+ahd_reg_print_t ahd_sghaddr_print;
 #else
-#define ahd_hodmaen_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HODMAEN", 0x7a, regvalue, cur_col, wrap)
+#define ahd_sghaddr_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SGHADDR", 0x7c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -1063,10 +776,10 @@ ahd_reg_print_t ahd_scbhaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghaddr_print;
+ahd_reg_print_t ahd_sghcnt_print;
 #else
-#define ahd_sghaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHADDR", 0x7c, regvalue, cur_col, wrap)
+#define ahd_sghcnt_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SGHCNT", 0x84, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -1077,13 +790,6 @@ ahd_reg_print_t ahd_scbhcnt_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghcnt_print;
-#else
-#define ahd_sghcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHCNT", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dff_thrsh_print;
 #else
 #define ahd_dff_thrsh_print(regvalue, cur_col, wrap) \
@@ -1091,132 +797,6 @@ ahd_reg_print_t ahd_dff_thrsh_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_romaddr_print;
-#else
-#define ahd_romaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ROMADDR", 0x8a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_romcntrl_print;
-#else
-#define ahd_romcntrl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ROMCNTRL", 0x8d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_romdata_print;
-#else
-#define ahd_romdata_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ROMDATA", 0x8e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcrxmsg0_print;
-#else
-#define ahd_cmcrxmsg0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCRXMSG0", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_roenable_print;
-#else
-#define ahd_roenable_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ROENABLE", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyrxmsg0_print;
-#else
-#define ahd_ovlyrxmsg0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYRXMSG0", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dchrxmsg0_print;
-#else
-#define ahd_dchrxmsg0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHRXMSG0", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyrxmsg1_print;
-#else
-#define ahd_ovlyrxmsg1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYRXMSG1", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_nsenable_print;
-#else
-#define ahd_nsenable_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NSENABLE", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcrxmsg1_print;
-#else
-#define ahd_cmcrxmsg1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCRXMSG1", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dchrxmsg1_print;
-#else
-#define ahd_dchrxmsg1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHRXMSG1", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dchrxmsg2_print;
-#else
-#define ahd_dchrxmsg2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHRXMSG2", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcrxmsg2_print;
-#else
-#define ahd_cmcrxmsg2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCRXMSG2", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ost_print;
-#else
-#define ahd_ost_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OST", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyrxmsg2_print;
-#else
-#define ahd_ovlyrxmsg2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYRXMSG2", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dchrxmsg3_print;
-#else
-#define ahd_dchrxmsg3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHRXMSG3", 0x93, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyrxmsg3_print;
-#else
-#define ahd_ovlyrxmsg3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYRXMSG3", 0x93, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcrxmsg3_print;
-#else
-#define ahd_cmcrxmsg3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCRXMSG3", 0x93, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_pcixctl_print;
 #else
 #define ahd_pcixctl_print(regvalue, cur_col, wrap) \
@@ -1224,34 +804,6 @@ ahd_reg_print_t ahd_pcixctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyseqbcnt_print;
-#else
-#define ahd_ovlyseqbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYSEQBCNT", 0x94, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dchseqbcnt_print;
-#else
-#define ahd_dchseqbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHSEQBCNT", 0x94, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcseqbcnt_print;
-#else
-#define ahd_cmcseqbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCSEQBCNT", 0x94, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcspltstat0_print;
-#else
-#define ahd_cmcspltstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCSPLTSTAT0", 0x96, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dchspltstat0_print;
 #else
 #define ahd_dchspltstat0_print(regvalue, cur_col, wrap) \
@@ -1259,27 +811,6 @@ ahd_reg_print_t ahd_dchspltstat0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyspltstat0_print;
-#else
-#define ahd_ovlyspltstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYSPLTSTAT0", 0x96, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcspltstat1_print;
-#else
-#define ahd_cmcspltstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCSPLTSTAT1", 0x97, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyspltstat1_print;
-#else
-#define ahd_ovlyspltstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYSPLTSTAT1", 0x97, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dchspltstat1_print;
 #else
 #define ahd_dchspltstat1_print(regvalue, cur_col, wrap) \
@@ -1287,90 +818,6 @@ ahd_reg_print_t ahd_dchspltstat1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgrxmsg0_print;
-#else
-#define ahd_sgrxmsg0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGRXMSG0", 0x98, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutadr0_print;
-#else
-#define ahd_slvspltoutadr0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTADR0", 0x98, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgrxmsg1_print;
-#else
-#define ahd_sgrxmsg1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGRXMSG1", 0x99, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutadr1_print;
-#else
-#define ahd_slvspltoutadr1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTADR1", 0x99, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgrxmsg2_print;
-#else
-#define ahd_sgrxmsg2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGRXMSG2", 0x9a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutadr2_print;
-#else
-#define ahd_slvspltoutadr2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTADR2", 0x9a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgrxmsg3_print;
-#else
-#define ahd_sgrxmsg3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGRXMSG3", 0x9b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutadr3_print;
-#else
-#define ahd_slvspltoutadr3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTADR3", 0x9b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgseqbcnt_print;
-#else
-#define ahd_sgseqbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGSEQBCNT", 0x9c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutattr0_print;
-#else
-#define ahd_slvspltoutattr0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTATTR0", 0x9c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutattr1_print;
-#else
-#define ahd_slvspltoutattr1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTATTR1", 0x9d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_slvspltoutattr2_print;
-#else
-#define ahd_slvspltoutattr2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SLVSPLTOUTATTR2", 0x9e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sgspltstat0_print;
 #else
 #define ahd_sgspltstat0_print(regvalue, cur_col, wrap) \
@@ -1385,13 +832,6 @@ ahd_reg_print_t ahd_sgspltstat1_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sfunct_print;
-#else
-#define ahd_sfunct_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SFUNCT", 0x9f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_df0pcistat_print;
 #else
 #define ahd_df0pcistat_print(regvalue, cur_col, wrap) \
@@ -1406,41 +846,6 @@ ahd_reg_print_t ahd_reg0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_df1pcistat_print;
-#else
-#define ahd_df1pcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DF1PCISTAT", 0xa1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgpcistat_print;
-#else
-#define ahd_sgpcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGPCISTAT", 0xa2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_reg1_print;
-#else
-#define ahd_reg1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "REG1", 0xa2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmcpcistat_print;
-#else
-#define ahd_cmcpcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMCPCISTAT", 0xa3, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlypcistat_print;
-#else
-#define ahd_ovlypcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYPCISTAT", 0xa4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_reg_isr_print;
 #else
 #define ahd_reg_isr_print(regvalue, cur_col, wrap) \
@@ -1455,13 +860,6 @@ ahd_reg_print_t ahd_sg_state_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_msipcistat_print;
-#else
-#define ahd_msipcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MSIPCISTAT", 0xa6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_targpcistat_print;
 #else
 #define ahd_targpcistat_print(regvalue, cur_col, wrap) \
@@ -1469,13 +867,6 @@ ahd_reg_print_t ahd_targpcistat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_data_count_odd_print;
-#else
-#define ahd_data_count_odd_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DATA_COUNT_ODD", 0xa7, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scbptr_print;
 #else
 #define ahd_scbptr_print(regvalue, cur_col, wrap) \
@@ -1483,13 +874,6 @@ ahd_reg_print_t ahd_scbptr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbacnt_print;
-#else
-#define ahd_ccscbacnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBACNT", 0xab, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scbautoptr_print;
 #else
 #define ahd_scbautoptr_print(regvalue, cur_col, wrap) \
@@ -1504,13 +888,6 @@ ahd_reg_print_t ahd_ccsgaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbadr_bk_print;
-#else
-#define ahd_ccscbadr_bk_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBADR_BK", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccscbaddr_print;
 #else
 #define ahd_ccscbaddr_print(regvalue, cur_col, wrap) \
@@ -1518,13 +895,6 @@ ahd_reg_print_t ahd_ccscbaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmc_rambist_print;
-#else
-#define ahd_cmc_rambist_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMC_RAMBIST", 0xad, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccscbctl_print;
 #else
 #define ahd_ccscbctl_print(regvalue, cur_col, wrap) \
@@ -1546,13 +916,6 @@ ahd_reg_print_t ahd_ccsgram_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flexadr_print;
-#else
-#define ahd_flexadr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLEXADR", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_ccscbram_print;
 #else
 #define ahd_ccscbram_print(regvalue, cur_col, wrap) \
@@ -1560,27 +923,6 @@ ahd_reg_print_t ahd_ccscbram_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flexcnt_print;
-#else
-#define ahd_flexcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLEXCNT", 0xb3, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flexdmastat_print;
-#else
-#define ahd_flexdmastat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLEXDMASTAT", 0xb5, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flexdata_print;
-#else
-#define ahd_flexdata_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLEXDATA", 0xb6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_brddat_print;
 #else
 #define ahd_brddat_print(regvalue, cur_col, wrap) \
@@ -1623,27 +965,6 @@ ahd_reg_print_t ahd_seestat_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbcnt_print;
-#else
-#define ahd_scbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBCNT", 0xbf, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfwaddr_print;
-#else
-#define ahd_dfwaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFWADDR", 0xc0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dspfltrctl_print;
-#else
-#define ahd_dspfltrctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSPFLTRCTL", 0xc0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dspdatactl_print;
 #else
 #define ahd_dspdatactl_print(regvalue, cur_col, wrap) \
@@ -1651,27 +972,6 @@ ahd_reg_print_t ahd_dspdatactl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfraddr_print;
-#else
-#define ahd_dfraddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFRADDR", 0xc2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dspreqctl_print;
-#else
-#define ahd_dspreqctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSPREQCTL", 0xc2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dspackctl_print;
-#else
-#define ahd_dspackctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSPACKCTL", 0xc3, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dfdat_print;
 #else
 #define ahd_dfdat_print(regvalue, cur_col, wrap) \
@@ -1693,76 +993,6 @@ ahd_reg_print_t ahd_wrtbiasctl_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_rcvrbiosctl_print;
-#else
-#define ahd_rcvrbiosctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "RCVRBIOSCTL", 0xc6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_wrtbiascalc_print;
-#else
-#define ahd_wrtbiascalc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "WRTBIASCALC", 0xc7, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_rcvrbiascalc_print;
-#else
-#define ahd_rcvrbiascalc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "RCVRBIASCALC", 0xc8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfptrs_print;
-#else
-#define ahd_dfptrs_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFPTRS", 0xc8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_skewcalc_print;
-#else
-#define ahd_skewcalc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SKEWCALC", 0xc9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfbkptr_print;
-#else
-#define ahd_dfbkptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFBKPTR", 0xc9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfdbctl_print;
-#else
-#define ahd_dfdbctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFDBCTL", 0xcb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfscnt_print;
-#else
-#define ahd_dfscnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFSCNT", 0xcc, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfbcnt_print;
-#else
-#define ahd_dfbcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFBCNT", 0xce, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ovlyaddr_print;
-#else
-#define ahd_ovlyaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OVLYADDR", 0xd4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqctl0_print;
 #else
 #define ahd_seqctl0_print(regvalue, cur_col, wrap) \
@@ -1770,13 +1000,6 @@ ahd_reg_print_t ahd_seqctl0_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqctl1_print;
-#else
-#define ahd_seqctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQCTL1", 0xd7, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_flags_print;
 #else
 #define ahd_flags_print(regvalue, cur_col, wrap) \
@@ -1826,20 +1049,6 @@ ahd_reg_print_t ahd_dindex_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_brkaddr0_print;
-#else
-#define ahd_brkaddr0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BRKADDR0", 0xe6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_brkaddr1_print;
-#else
-#define ahd_brkaddr1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BRKADDR1", 0xe6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_allones_print;
 #else
 #define ahd_allones_print(regvalue, cur_col, wrap) \
@@ -1875,13 +1084,6 @@ ahd_reg_print_t ahd_dindir_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_function1_print;
-#else
-#define ahd_function1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FUNCTION1", 0xf0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_stack_print;
 #else
 #define ahd_stack_print(regvalue, cur_col, wrap) \
@@ -1903,13 +1105,6 @@ ahd_reg_print_t ahd_curaddr_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lastaddr_print;
-#else
-#define ahd_lastaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LASTADDR", 0xf6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_intvec2_addr_print;
 #else
 #define ahd_intvec2_addr_print(regvalue, cur_col, wrap) \
@@ -1931,24 +1126,17 @@ ahd_reg_print_t ahd_accum_save_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_waiting_scb_tails_print;
-#else
-#define ahd_waiting_scb_tails_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "WAITING_SCB_TAILS", 0x100, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ahd_pci_config_base_print;
+ahd_reg_print_t ahd_sram_base_print;
 #else
-#define ahd_ahd_pci_config_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "AHD_PCI_CONFIG_BASE", 0x100, regvalue, cur_col, wrap)
+#define ahd_sram_base_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sram_base_print;
+ahd_reg_print_t ahd_waiting_scb_tails_print;
 #else
-#define ahd_sram_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SRAM_BASE", 0x100, regvalue, cur_col, wrap)
+#define ahd_waiting_scb_tails_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "WAITING_SCB_TAILS", 0x100, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -2218,17 +1406,17 @@ ahd_reg_print_t ahd_mk_message_scsiid_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_base_print;
+ahd_reg_print_t ahd_scb_residual_datacnt_print;
 #else
-#define ahd_scb_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_BASE", 0x180, regvalue, cur_col, wrap)
+#define ahd_scb_residual_datacnt_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT", 0x180, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_residual_datacnt_print;
+ahd_reg_print_t ahd_scb_base_print;
 #else
-#define ahd_scb_residual_datacnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT", 0x180, regvalue, cur_col, wrap)
+#define ahd_scb_base_print(regvalue, cur_col, wrap) \
+    ahd_print_register(NULL, 0, "SCB_BASE", 0x180, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
@@ -2246,27 +1434,6 @@ ahd_reg_print_t ahd_scb_scsi_status_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_target_phases_print;
-#else
-#define ahd_scb_target_phases_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_TARGET_PHASES", 0x189, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_target_data_dir_print;
-#else
-#define ahd_scb_target_data_dir_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_TARGET_DATA_DIR", 0x18a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_target_itag_print;
-#else
-#define ahd_scb_target_itag_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_TARGET_ITAG", 0x18b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_sense_busaddr_print;
 #else
 #define ahd_scb_sense_busaddr_print(regvalue, cur_col, wrap) \
@@ -2365,13 +1532,6 @@ ahd_reg_print_t ahd_scb_next2_print;
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scb_spare_print;
-#else
-#define ahd_scb_spare_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCB_SPARE", 0x1b0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #else
 #define ahd_scb_disconnected_lists_print(regvalue, cur_col, wrap) \
@@ -2557,10 +1717,10 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	SG_CACHE_PRE    		0x1b
 
-#define	LQIN            		0x20
-
 #define	TYPEPTR         		0x20
 
+#define	LQIN            		0x20
+
 #define	TAGPTR          		0x21
 
 #define	LUNPTR          		0x22
@@ -2620,14 +1780,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		SINGLECMD       	0x02
 #define		ABORTPENDING    	0x01
 
-#define	SCSBIST0        		0x39
-#define		GSBISTERR       	0x40
-#define		GSBISTDONE      	0x20
-#define		GSBISTRUN       	0x10
-#define		OSBISTERR       	0x04
-#define		OSBISTDONE      	0x02
-#define		OSBISTRUN       	0x01
-
 #define	LQCTL2          		0x39
 #define		LQIRETRY        	0x80
 #define		LQICONTINUE     	0x40
@@ -2638,10 +1790,13 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		LQOTOIDLE       	0x02
 #define		LQOPAUSE        	0x01
 
-#define	SCSBIST1        		0x3a
-#define		NTBISTERR       	0x04
-#define		NTBISTDONE      	0x02
-#define		NTBISTRUN       	0x01
+#define	SCSBIST0        		0x39
+#define		GSBISTERR       	0x40
+#define		GSBISTDONE      	0x20
+#define		GSBISTRUN       	0x10
+#define		OSBISTERR       	0x04
+#define		OSBISTDONE      	0x02
+#define		OSBISTRUN       	0x01
 
 #define	SCSISEQ0        		0x3a
 #define		TEMODEO         	0x80
@@ -2650,8 +1805,15 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		FORCEBUSFREE    	0x10
 #define		SCSIRSTO        	0x01
 
+#define	SCSBIST1        		0x3a
+#define		NTBISTERR       	0x04
+#define		NTBISTDONE      	0x02
+#define		NTBISTRUN       	0x01
+
 #define	SCSISEQ1        		0x3b
 
+#define	BUSINITID       		0x3c
+
 #define	SXFRCTL0        		0x3c
 #define		DFON            	0x80
 #define		DFPEXP          	0x40
@@ -2660,8 +1822,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	DLCOUNT         		0x3c
 
-#define	BUSINITID       		0x3c
-
 #define	SXFRCTL1        		0x3d
 #define		BITBUCKET       	0x80
 #define		ENSACHK         	0x40
@@ -2686,6 +1846,8 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		CURRFIFO_1      	0x01
 #define		CURRFIFO_0      	0x00
 
+#define	MULTARGID       		0x40
+
 #define	SCSISIGO        		0x40
 #define		CDO             	0x80
 #define		IOO             	0x40
@@ -2696,8 +1858,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		REQO            	0x02
 #define		ACKO            	0x01
 
-#define	MULTARGID       		0x40
-
 #define	SCSISIGI        		0x41
 #define		ATNI            	0x10
 #define		SELI            	0x08
@@ -2744,15 +1904,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		ENAB20          	0x04
 #define		SELWIDE         	0x02
 
-#define	CLRSINT0        		0x4b
-#define		CLRSELDO        	0x40
-#define		CLRSELDI        	0x20
-#define		CLRSELINGO      	0x10
-#define		CLRIOERR        	0x08
-#define		CLROVERRUN      	0x04
-#define		CLRSPIORDY      	0x02
-#define		CLRARBDO        	0x01
-
 #define	SSTAT0          		0x4b
 #define		TARGET          	0x80
 #define		SELDO           	0x40
@@ -2772,14 +1923,14 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		ENSPIORDY       	0x02
 #define		ENARBDO         	0x01
 
-#define	CLRSINT1        		0x4c
-#define		CLRSELTIMEO     	0x80
-#define		CLRATNO         	0x40
-#define		CLRSCSIRSTI     	0x20
-#define		CLRBUSFREE      	0x08
-#define		CLRSCSIPERR     	0x04
-#define		CLRSTRB2FAST    	0x02
-#define		CLRREQINIT      	0x01
+#define	CLRSINT0        		0x4b
+#define		CLRSELDO        	0x40
+#define		CLRSELDI        	0x20
+#define		CLRSELINGO      	0x10
+#define		CLRIOERR        	0x08
+#define		CLROVERRUN      	0x04
+#define		CLRSPIORDY      	0x02
+#define		CLRARBDO        	0x01
 
 #define	SSTAT1          		0x4c
 #define		SELTO           	0x80
@@ -2791,6 +1942,15 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		STRB2FAST       	0x02
 #define		REQINIT         	0x01
 
+#define	CLRSINT1        		0x4c
+#define		CLRSELTIMEO     	0x80
+#define		CLRATNO         	0x40
+#define		CLRSCSIRSTI     	0x20
+#define		CLRBUSFREE      	0x08
+#define		CLRSCSIPERR     	0x04
+#define		CLRSTRB2FAST    	0x02
+#define		CLRREQINIT      	0x01
+
 #define	SSTAT2          		0x4d
 #define		BUSFREETIME     	0xc0
 #define		NONPACKREQ      	0x20
@@ -2838,14 +1998,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		LQIATNLQ        	0x02
 #define		LQIATNCMD       	0x01
 
-#define	CLRLQIINT0      		0x50
-#define		CLRLQIATNQAS    	0x20
-#define		CLRLQICRCT1     	0x10
-#define		CLRLQICRCT2     	0x08
-#define		CLRLQIBADLQT    	0x04
-#define		CLRLQIATNLQ     	0x02
-#define		CLRLQIATNCMD    	0x01
-
 #define	LQIMODE0        		0x50
 #define		ENLQIATNQASK    	0x20
 #define		ENLQICRCT1      	0x10
@@ -2854,6 +2006,14 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		ENLQIATNLQ      	0x02
 #define		ENLQIATNCMD     	0x01
 
+#define	CLRLQIINT0      		0x50
+#define		CLRLQIATNQAS    	0x20
+#define		CLRLQICRCT1     	0x10
+#define		CLRLQICRCT2     	0x08
+#define		CLRLQIBADLQT    	0x04
+#define		CLRLQIATNLQ     	0x02
+#define		CLRLQIATNCMD    	0x01
+
 #define	LQIMODE1        		0x51
 #define		ENLQIPHASE_LQ   	0x80
 #define		ENLQIPHASE_NLQ  	0x40
@@ -2976,6 +2136,8 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	LQOSCSCTL       		0x5a
 #define		LQOH2A_VERSION  	0x80
+#define		LQOBUSETDLY     	0x40
+#define		LQONOHOLDLACK   	0x02
 #define		LQONOCHKOVER    	0x01
 
 #define	NEXTSCB         		0x5a
@@ -2998,8 +2160,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		CFG4ICMD        	0x02
 #define		CFG4TCMD        	0x01
 
-#define	CURRSCB         		0x5c
-
 #define	SEQIMODE        		0x5c
 #define		ENCTXTDONE      	0x40
 #define		ENSAVEPTRS      	0x20
@@ -3009,6 +2169,8 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		ENCFG4ICMD      	0x02
 #define		ENCFG4TCMD      	0x01
 
+#define	CURRSCB         		0x5c
+
 #define	MDFFSTAT        		0x5d
 #define		SHCNTNEGATIVE   	0x40
 #define		SHCNTMINUS1     	0x20
@@ -3023,29 +2185,29 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	DFFTAG          		0x5e
 
-#define	LASTSCB         		0x5e
-
 #define	SCSITEST        		0x5e
 #define		CNTRTEST        	0x08
 #define		SEL_TXPLL_DEBUG 	0x04
 
+#define	LASTSCB         		0x5e
+
 #define	IOPDNCTL        		0x5f
 #define		DISABLE_OE      	0x80
 #define		PDN_IDIST       	0x04
 #define		PDN_DIFFSENSE   	0x01
 
+#define	DGRPCRCI        		0x60
+
 #define	SHADDR          		0x60
 
 #define	NEGOADDR        		0x60
 
-#define	DGRPCRCI        		0x60
-
 #define	NEGPERIOD       		0x61
 
-#define	PACKCRCI        		0x62
-
 #define	NEGOFFSET       		0x62
 
+#define	PACKCRCI        		0x62
+
 #define	NEGPPROPTS      		0x63
 #define		PPROPT_PACE     	0x08
 #define		PPROPT_QAS      	0x04
@@ -3066,6 +2228,7 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define	ANNEXDAT        		0x66
 
 #define	SCSCHKN         		0x66
+#define		BIDICHKDIS      	0x80
 #define		STSELSKIDDIS    	0x40
 #define		CURRFIFODEF     	0x20
 #define		WIDERESEN       	0x10
@@ -3090,6 +2253,8 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	SELOID          		0x6b
 
+#define	FAIRNESS        		0x6c
+
 #define	PLL400CTL0      		0x6c
 #define		PLL_VCOSEL      	0x80
 #define		PLL_PWDN        	0x40
@@ -3099,8 +2264,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		PLL_DLPF        	0x02
 #define		PLL_ENFBM       	0x01
 
-#define	FAIRNESS        		0x6c
-
 #define	PLL400CTL1      		0x6d
 #define		PLL_CNTEN       	0x80
 #define		PLL_CNTCLR      	0x40
@@ -3112,25 +2275,25 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	HADDR           		0x70
 
+#define	HODMAADR        		0x70
+
 #define	PLLDELAY        		0x70
 #define		SPLIT_DROP_REQ  	0x80
 
-#define	HODMAADR        		0x70
+#define	HCNT            		0x78
 
 #define	HODMACNT        		0x78
 
-#define	HCNT            		0x78
-
 #define	HODMAEN         		0x7a
 
-#define	SCBHADDR        		0x7c
-
 #define	SGHADDR         		0x7c
 
-#define	SCBHCNT         		0x84
+#define	SCBHADDR        		0x7c
 
 #define	SGHCNT          		0x84
 
+#define	SCBHCNT         		0x84
+
 #define	DFF_THRSH       		0x88
 #define		WR_DFTHRSH      	0x70
 #define		RD_DFTHRSH      	0x07
@@ -3163,6 +2326,10 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	CMCRXMSG0       		0x90
 
+#define	OVLYRXMSG0      		0x90
+
+#define	DCHRXMSG0       		0x90
+
 #define	ROENABLE        		0x90
 #define		MSIROEN         	0x20
 #define		OVLYROEN        	0x10
@@ -3171,11 +2338,11 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		DCH1ROEN        	0x02
 #define		DCH0ROEN        	0x01
 
-#define	OVLYRXMSG0      		0x90
+#define	OVLYRXMSG1      		0x91
 
-#define	DCHRXMSG0       		0x90
+#define	CMCRXMSG1       		0x91
 
-#define	OVLYRXMSG1      		0x91
+#define	DCHRXMSG1       		0x91
 
 #define	NSENABLE        		0x91
 #define		MSINSEN         	0x20
@@ -3185,10 +2352,6 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		DCH1NSEN        	0x02
 #define		DCH0NSEN        	0x01
 
-#define	CMCRXMSG1       		0x91
-
-#define	DCHRXMSG1       		0x91
-
 #define	DCHRXMSG2       		0x92
 
 #define	CMCRXMSG2       		0x92
@@ -3212,24 +2375,24 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		TSCSERREN       	0x02
 #define		CMPABCDIS       	0x01
 
+#define	CMCSEQBCNT      		0x94
+
 #define	OVLYSEQBCNT     		0x94
 
 #define	DCHSEQBCNT      		0x94
 
-#define	CMCSEQBCNT      		0x94
-
-#define	CMCSPLTSTAT0    		0x96
-
 #define	DCHSPLTSTAT0    		0x96
 
 #define	OVLYSPLTSTAT0   		0x96
 
-#define	CMCSPLTSTAT1    		0x97
+#define	CMCSPLTSTAT0    		0x96
 
 #define	OVLYSPLTSTAT1   		0x97
 
 #define	DCHSPLTSTAT1    		0x97
 
+#define	CMCSPLTSTAT1    		0x97
+
 #define	SGRXMSG0        		0x98
 #define		CDNUM           	0xf8
 #define		CFNUM           	0x07
@@ -3257,18 +2420,15 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		TAG_NUM         	0x1f
 #define		RLXORD          	0x10
 
-#define	SGSEQBCNT       		0x9c
-
 #define	SLVSPLTOUTATTR0 		0x9c
 #define		LOWER_BCNT      	0xff
 
+#define	SGSEQBCNT       		0x9c
+
 #define	SLVSPLTOUTATTR1 		0x9d
 #define		CMPLT_DNUM      	0xf8
 #define		CMPLT_FNUM      	0x07
 
-#define	SLVSPLTOUTATTR2 		0x9e
-#define		CMPLT_BNUM      	0xff
-
 #define	SGSPLTSTAT0     		0x9e
 #define		STAETERM        	0x80
 #define		SCBCERR         	0x40
@@ -3279,6 +2439,9 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		RXSCEMSG        	0x02
 #define		RXSPLTRSP       	0x01
 
+#define	SLVSPLTOUTATTR2 		0x9e
+#define		CMPLT_BNUM      	0xff
+
 #define	SGSPLTSTAT1     		0x9f
 #define		RXDATABUCKET    	0x01
 
@@ -3334,10 +2497,10 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	CCSGADDR        		0xac
 
-#define	CCSCBADR_BK     		0xac
-
 #define	CCSCBADDR       		0xac
 
+#define	CCSCBADR_BK     		0xac
+
 #define	CMC_RAMBIST     		0xad
 #define		SG_ELEMENT_SIZE 	0x80
 #define		SCBRAMBIST_FAIL 	0x40
@@ -3391,9 +2554,9 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define	SEEDAT          		0xbc
 
 #define	SEECTL          		0xbe
+#define		SEEOP_EWDS      	0x40
 #define		SEEOP_WALL      	0x40
 #define		SEEOP_EWEN      	0x40
-#define		SEEOP_EWDS      	0x40
 #define		SEEOPCODE       	0x70
 #define		SEERST          	0x02
 #define		SEESTART        	0x01
@@ -3410,25 +2573,25 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	SCBCNT          		0xbf
 
-#define	DFWADDR         		0xc0
-
 #define	DSPFLTRCTL      		0xc0
 #define		FLTRDISABLE     	0x20
 #define		EDGESENSE       	0x10
 #define		DSPFCNTSEL      	0x0f
 
+#define	DFWADDR         		0xc0
+
 #define	DSPDATACTL      		0xc1
 #define		BYPASSENAB      	0x80
 #define		DESQDIS         	0x10
 #define		RCVROFFSTDIS    	0x04
 #define		XMITOFFSTDIS    	0x02
 
-#define	DFRADDR         		0xc2
-
 #define	DSPREQCTL       		0xc2
 #define		MANREQCTL       	0xc0
 #define		MANREQDLY       	0x3f
 
+#define	DFRADDR         		0xc2
+
 #define	DSPACKCTL       		0xc3
 #define		MANACKCTL       	0xc0
 #define		MANACKDLY       	0x3f
@@ -3449,14 +2612,14 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	WRTBIASCALC     		0xc7
 
-#define	RCVRBIASCALC    		0xc8
-
 #define	DFPTRS          		0xc8
 
-#define	SKEWCALC        		0xc9
+#define	RCVRBIASCALC    		0xc8
 
 #define	DFBKPTR         		0xc9
 
+#define	SKEWCALC        		0xc9
+
 #define	DFDBCTL         		0xcb
 #define		DFF_CIO_WR_RDY  	0x20
 #define		DFF_CIO_RD_RDY  	0x10
@@ -3541,12 +2704,12 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	ACCUM_SAVE      		0xfa
 
-#define	WAITING_SCB_TAILS		0x100
-
 #define	AHD_PCI_CONFIG_BASE		0x100
 
 #define	SRAM_BASE       		0x100
 
+#define	WAITING_SCB_TAILS		0x100
+
 #define	WAITING_TID_HEAD		0x120
 
 #define	WAITING_TID_TAIL		0x122
@@ -3575,8 +2738,8 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define		PRELOADEN       	0x80
 #define		WIDEODD         	0x40
 #define		SCSIEN          	0x20
-#define		SDMAEN          	0x10
 #define		SDMAENACK       	0x10
+#define		SDMAEN          	0x10
 #define		HDMAEN          	0x08
 #define		HDMAENACK       	0x08
 #define		DIRECTION       	0x04
@@ -3674,12 +2837,12 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 
 #define	MK_MESSAGE_SCSIID		0x162
 
-#define	SCB_BASE        		0x180
-
 #define	SCB_RESIDUAL_DATACNT		0x180
 #define	SCB_CDB_STORE   		0x180
 #define	SCB_HOST_CDB_PTR		0x180
 
+#define	SCB_BASE        		0x180
+
 #define	SCB_RESIDUAL_SGPTR		0x184
 #define		SG_ADDR_MASK    	0xf8
 #define		SG_OVERRUN_RESID	0x02
@@ -3747,6 +2910,17 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define	SCB_DISCONNECTED_LISTS		0x1b8
 
 
+#define	CMD_GROUP_CODE_SHIFT	0x05
+#define	STIMESEL_MIN	0x18
+#define	STIMESEL_SHIFT	0x03
+#define	INVALID_ADDR	0x80
+#define	AHD_PRECOMP_MASK	0x07
+#define	TARGET_DATA_IN	0x01
+#define	CCSCBADDR_MAX	0x80
+#define	NUMDSPS 	0x14
+#define	SEEOP_EWEN_ADDR	0xc0
+#define	AHD_ANNEXCOL_PER_DEV0	0x04
+#define	DST_MODE_SHIFT	0x04
 #define	AHD_TIMER_MAX_US	0x18ffe7
 #define	AHD_TIMER_MAX_TICKS	0xffff
 #define	AHD_SENSE_BUFSIZE	0x100
@@ -3781,43 +2955,32 @@ ahd_reg_print_t ahd_scb_disconnected_lists_print;
 #define	LUNLEN_SINGLE_LEVEL_LUN	0x0f
 #define	NVRAM_SCB_OFFSET	0x2c
 #define	STATUS_PKT_SENSE	0xff
-#define	CMD_GROUP_CODE_SHIFT	0x05
 #define	MAX_OFFSET_PACED_BUG	0x7f
 #define	STIMESEL_BUG_ADJ	0x08
-#define	STIMESEL_MIN	0x18
-#define	STIMESEL_SHIFT	0x03
 #define	CCSGRAM_MAXSEGS	0x10
-#define	INVALID_ADDR	0x80
 #define	SEEOP_ERAL_ADDR	0x80
 #define	AHD_SLEWRATE_DEF_REVB	0x08
 #define	AHD_PRECOMP_CUTBACK_17	0x04
-#define	AHD_PRECOMP_MASK	0x07
 #define	SRC_MODE_SHIFT	0x00
 #define	PKT_OVERRUN_BUFSIZE	0x200
 #define	SCB_TRANSFER_SIZE_1BYTE_LUN	0x30
-#define	TARGET_DATA_IN	0x01
 #define	HOST_MSG	0xff
 #define	MAX_OFFSET	0xfe
 #define	BUS_16_BIT	0x01
-#define	CCSCBADDR_MAX	0x80
-#define	NUMDSPS 	0x14
-#define	SEEOP_EWEN_ADDR	0xc0
-#define	AHD_ANNEXCOL_PER_DEV0	0x04
-#define	DST_MODE_SHIFT	0x04
 
 
 /* Downloaded Constant Definitions */
+#define	SG_SIZEOF	0x04
+#define	SG_PREFETCH_ALIGN_MASK	0x02
+#define	SG_PREFETCH_CNT_LIMIT	0x01
 #define	CACHELINE_MASK	0x07
 #define	SCB_TRANSFER_SIZE	0x06
 #define	PKT_OVERRUN_BUFOFFSET	0x05
-#define	SG_SIZEOF	0x04
 #define	SG_PREFETCH_ADDR_MASK	0x03
-#define	SG_PREFETCH_ALIGN_MASK	0x02
-#define	SG_PREFETCH_CNT_LIMIT	0x01
 #define	SG_PREFETCH_CNT	0x00
 #define	DOWNLOAD_CONST_COUNT	0x08
 
 
 /* Exported Labels */
-#define	LABEL_seq_isr 	0x28f
 #define	LABEL_timer_isr	0x28b
+#define	LABEL_seq_isr 	0x28f
diff --git a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped b/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
index db38a61..c4c8a96 100644
--- a/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped
@@ -8,7 +8,7 @@
 
 #include "aic79xx_osm.h"
 
-static ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
+static const ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
 	{ "SRC_MODE",		0x07, 0x07 },
 	{ "DST_MODE",		0x70, 0x70 }
 };
@@ -20,7 +20,7 @@ ahd_mode_ptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x00, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SPLTINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
 	{ "SEQINT",		0x04, 0x04 },
@@ -39,7 +39,7 @@ ahd_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
 	{ "NO_SEQINT",		0x00, 0xff },
 	{ "BAD_PHASE",		0x01, 0xff },
 	{ "SEND_REJECT",	0x02, 0xff },
@@ -76,7 +76,7 @@ ahd_seqintcode_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x02, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRINT_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRINT_parse_table[] = {
 	{ "CLRSPLTINT",		0x01, 0x01 },
 	{ "CLRCMDINT",		0x02, 0x02 },
 	{ "CLRSEQINT",		0x04, 0x04 },
@@ -94,7 +94,7 @@ ahd_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ERROR_parse_table[] = {
+static const ahd_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "DSCTMOUT",		0x02, 0x02 },
 	{ "ILLOPCODE",		0x04, 0x04 },
 	{ "SQPARERR",		0x08, 0x08 },
@@ -111,24 +111,7 @@ ahd_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRERR_parse_table[] = {
-	{ "CLRDSCTMOUT",	0x02, 0x02 },
-	{ "CLRILLOPCODE",	0x04, 0x04 },
-	{ "CLRSQPARERR",	0x08, 0x08 },
-	{ "CLRDPARERR",		0x10, 0x10 },
-	{ "CLRMPARERR",		0x20, 0x20 },
-	{ "CLRCIOACCESFAIL",	0x40, 0x40 },
-	{ "CLRCIOPARERR",	0x80, 0x80 }
-};
-
-int
-ahd_clrerr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRERR_parse_table, 7, "CLRERR",
-	    0x04, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t HCNTRL_parse_table[] = {
+static const ahd_reg_parse_entry_t HCNTRL_parse_table[] = {
 	{ "CHIPRST",		0x01, 0x01 },
 	{ "CHIPRSTACK",		0x01, 0x01 },
 	{ "INTEN",		0x02, 0x02 },
@@ -160,7 +143,7 @@ ahd_hescb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x08, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+static const ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "ENINT_COALESCE",	0x40, 0x40 },
 	{ "HOST_TQINPOS",	0x80, 0x80 }
 };
@@ -172,7 +155,7 @@ ahd_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
 	{ "SEQ_SPLTINT",	0x01, 0x01 },
 	{ "SEQ_PCIINT",		0x02, 0x02 },
 	{ "SEQ_SCSIINT",	0x04, 0x04 },
@@ -187,7 +170,7 @@ ahd_seqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
 	{ "CLRSEQ_SPLTINT",	0x01, 0x01 },
 	{ "CLRSEQ_PCIINT",	0x02, 0x02 },
 	{ "CLRSEQ_SCSIINT",	0x04, 0x04 },
@@ -230,7 +213,7 @@ ahd_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x14, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
+static const ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
 	{ "SCB_QSIZE_4",	0x00, 0x0f },
 	{ "SCB_QSIZE_8",	0x01, 0x0f },
 	{ "SCB_QSIZE_16",	0x02, 0x0f },
@@ -258,7 +241,7 @@ ahd_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x16, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t INTCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
 	{ "SPLTINTEN",		0x01, 0x01 },
 	{ "SEQINTEN",		0x02, 0x02 },
 	{ "SCSIINTEN",		0x04, 0x04 },
@@ -276,7 +259,7 @@ ahd_intctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x18, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "DIRECTIONEN",	0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "FIFOFLUSHACK",	0x02, 0x02 },
@@ -297,7 +280,7 @@ ahd_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
+static const ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
 	{ "CIOPARCKEN",		0x01, 0x01 },
 	{ "DISABLE_TWATE",	0x02, 0x02 },
 	{ "EXTREQLCK",		0x10, 0x10 },
@@ -313,7 +296,7 @@ ahd_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
@@ -330,7 +313,7 @@ ahd_dfstatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "ODD_SEG",		0x04, 0x04 },
@@ -344,20 +327,7 @@ ahd_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ARBCTL_parse_table[] = {
-	{ "USE_TIME",		0x07, 0x07 },
-	{ "RETRY_SWEN",		0x08, 0x08 },
-	{ "RESET_HARB",		0x80, 0x80 }
-};
-
-int
-ahd_arbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ARBCTL_parse_table, 3, "ARBCTL",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "ODD_SEG",		0x04, 0x04 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -378,20 +348,6 @@ ahd_lqin_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_typeptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "TYPEPTR",
-	    0x20, regvalue, cur_col, wrap));
-}
-
-int
-ahd_tagptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "TAGPTR",
-	    0x21, regvalue, cur_col, wrap));
-}
-
-int
 ahd_lunptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "LUNPTR",
@@ -399,20 +355,6 @@ ahd_lunptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_datalenptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DATALENPTR",
-	    0x23, regvalue, cur_col, wrap));
-}
-
-int
-ahd_statlenptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "STATLENPTR",
-	    0x24, regvalue, cur_col, wrap));
-}
-
-int
 ahd_cmdlenptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "CMDLENPTR",
@@ -448,13 +390,6 @@ ahd_qnextptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_idptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "IDPTR",
-	    0x2a, regvalue, cur_col, wrap));
-}
-
-int
 ahd_abrtbyteptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "ABRTBYTEPTR",
@@ -468,28 +403,7 @@ ahd_abrtbitptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x2c, regvalue, cur_col, wrap));
 }
 
-int
-ahd_maxcmdbytes_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMDBYTES",
-	    0x2d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_maxcmd2rcv_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMD2RCV",
-	    0x2e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_shortthresh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SHORTTHRESH",
-	    0x2f, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LUNLEN_parse_table[] = {
+static const ahd_reg_parse_entry_t LUNLEN_parse_table[] = {
 	{ "ILUNLEN",		0x0f, 0x0f },
 	{ "TLUNLEN",		0xf0, 0xf0 }
 };
@@ -522,49 +436,7 @@ ahd_maxcmdcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x33, regvalue, cur_col, wrap));
 }
 
-int
-ahd_lqrsvd01_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQRSVD01",
-	    0x34, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lqrsvd16_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQRSVD16",
-	    0x35, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lqrsvd17_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQRSVD17",
-	    0x36, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmdrsvd0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDRSVD0",
-	    0x37, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQCTL0_parse_table[] = {
-	{ "LQ0INITGCLT",	0x03, 0x03 },
-	{ "LQ0TARGCLT",		0x0c, 0x0c },
-	{ "LQIINITGCLT",	0x30, 0x30 },
-	{ "LQITARGCLT",		0xc0, 0xc0 }
-};
-
-int
-ahd_lqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQCTL0_parse_table, 4, "LQCTL0",
-	    0x38, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQCTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQCTL1_parse_table[] = {
 	{ "ABORTPENDING",	0x01, 0x01 },
 	{ "SINGLECMD",		0x02, 0x02 },
 	{ "PCI2PCI",		0x04, 0x04 }
@@ -577,23 +449,7 @@ ahd_lqctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x38, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSBIST0_parse_table[] = {
-	{ "OSBISTRUN",		0x01, 0x01 },
-	{ "OSBISTDONE",		0x02, 0x02 },
-	{ "OSBISTERR",		0x04, 0x04 },
-	{ "GSBISTRUN",		0x10, 0x10 },
-	{ "GSBISTDONE",		0x20, 0x20 },
-	{ "GSBISTERR",		0x40, 0x40 }
-};
-
-int
-ahd_scsbist0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSBIST0_parse_table, 6, "SCSBIST0",
-	    0x39, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQCTL2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQCTL2_parse_table[] = {
 	{ "LQOPAUSE",		0x01, 0x01 },
 	{ "LQOTOIDLE",		0x02, 0x02 },
 	{ "LQOCONTINUE",	0x04, 0x04 },
@@ -611,20 +467,7 @@ ahd_lqctl2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x39, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSBIST1_parse_table[] = {
-	{ "NTBISTRUN",		0x01, 0x01 },
-	{ "NTBISTDONE",		0x02, 0x02 },
-	{ "NTBISTERR",		0x04, 0x04 }
-};
-
-int
-ahd_scsbist1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSBIST1_parse_table, 3, "SCSBIST1",
-	    0x3a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ0_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "FORCEBUSFREE",	0x10, 0x10 },
 	{ "ENARBO",		0x20, 0x20 },
@@ -639,7 +482,7 @@ ahd_scsiseq0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
@@ -655,7 +498,7 @@ ahd_scsiseq1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "SPIOEN",		0x08, 0x08 },
 	{ "BIOSCANCELEN",	0x10, 0x10 },
 	{ "DFPEXP",		0x40, 0x40 },
@@ -669,21 +512,7 @@ ahd_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3c, regvalue, cur_col, wrap));
 }
 
-int
-ahd_dlcount_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DLCOUNT",
-	    0x3c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_businitid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "BUSINITID",
-	    0x3c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SXFRCTL1_parse_table[] = {
+static const ahd_reg_parse_entry_t SXFRCTL1_parse_table[] = {
 	{ "STPWEN",		0x01, 0x01 },
 	{ "ACTNEGEN",		0x02, 0x02 },
 	{ "ENSTIMER",		0x04, 0x04 },
@@ -700,27 +529,7 @@ ahd_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3d, regvalue, cur_col, wrap));
 }
 
-int
-ahd_bustargid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "BUSTARGID",
-	    0x3e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SXFRCTL2_parse_table[] = {
-	{ "ASU",		0x07, 0x07 },
-	{ "CMDDMAEN",		0x08, 0x08 },
-	{ "AUTORSTDIS",		0x10, 0x10 }
-};
-
-int
-ahd_sxfrctl2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SXFRCTL2_parse_table, 3, "SXFRCTL2",
-	    0x3e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t DFFSTAT_parse_table[] = {
 	{ "CURRFIFO_0",		0x00, 0x03 },
 	{ "CURRFIFO_1",		0x01, 0x03 },
 	{ "CURRFIFO_NONE",	0x03, 0x03 },
@@ -736,7 +545,14 @@ ahd_dffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
+int
+ahd_multargid_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "MULTARGID",
+	    0x40, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -763,14 +579,7 @@ ahd_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x40, regvalue, cur_col, wrap));
 }
 
-int
-ahd_multargid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MULTARGID",
-	    0x40, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -797,7 +606,7 @@ ahd_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x41, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_OUT_PHASE",	0x01, 0x03 },
 	{ "DATA_IN_PHASE",	0x02, 0x03 },
 	{ "DATA_PHASE_MASK",	0x03, 0x03 },
@@ -815,13 +624,6 @@ ahd_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_scsidat0_img_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCSIDAT0_IMG",
-	    0x43, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scsidat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCSIDAT",
@@ -835,7 +637,7 @@ ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x46, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
+static const ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
 	{ "TARGID",		0x0f, 0x0f },
 	{ "CLKOUT",		0x80, 0x80 }
 };
@@ -847,7 +649,7 @@ ahd_targidin_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x48, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SELID_parse_table[] = {
+static const ahd_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
 };
@@ -859,7 +661,7 @@ ahd_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x49, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
+static const ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
 	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
 	{ "ENDGFORMCHK",	0x04, 0x04 },
 	{ "BUSFREEREV",		0x10, 0x10 },
@@ -876,7 +678,7 @@ ahd_optionmode_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "SELWIDE",		0x02, 0x02 },
 	{ "ENAB20",		0x04, 0x04 },
 	{ "ENAB40",		0x08, 0x08 },
@@ -891,24 +693,7 @@ ahd_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT0_parse_table[] = {
-	{ "CLRARBDO",		0x01, 0x01 },
-	{ "CLRSPIORDY",		0x02, 0x02 },
-	{ "CLROVERRUN",		0x04, 0x04 },
-	{ "CLRIOERR",		0x08, 0x08 },
-	{ "CLRSELINGO",		0x10, 0x10 },
-	{ "CLRSELDI",		0x20, 0x20 },
-	{ "CLRSELDO",		0x40, 0x40 }
-};
-
-int
-ahd_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT0_parse_table, 7, "CLRSINT0",
-	    0x4b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "ARBDO",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
 	{ "OVERRUN",		0x04, 0x04 },
@@ -926,7 +711,7 @@ ahd_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENARBDO",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENOVERRUN",		0x04, 0x04 },
@@ -943,24 +728,24 @@ ahd_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT1_parse_table[] = {
-	{ "CLRREQINIT",		0x01, 0x01 },
-	{ "CLRSTRB2FAST",	0x02, 0x02 },
-	{ "CLRSCSIPERR",	0x04, 0x04 },
-	{ "CLRBUSFREE",		0x08, 0x08 },
-	{ "CLRSCSIRSTI",	0x20, 0x20 },
-	{ "CLRATNO",		0x40, 0x40 },
-	{ "CLRSELTIMEO",	0x80, 0x80 }
+static const ahd_reg_parse_entry_t CLRSINT0_parse_table[] = {
+	{ "CLRARBDO",		0x01, 0x01 },
+	{ "CLRSPIORDY",		0x02, 0x02 },
+	{ "CLROVERRUN",		0x04, 0x04 },
+	{ "CLRIOERR",		0x08, 0x08 },
+	{ "CLRSELINGO",		0x10, 0x10 },
+	{ "CLRSELDI",		0x20, 0x20 },
+	{ "CLRSELDO",		0x40, 0x40 }
 };
 
 int
-ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x4c, regvalue, cur_col, wrap));
+	return (ahd_print_register(CLRSINT0_parse_table, 7, "CLRSINT0",
+	    0x4b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "STRB2FAST",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
@@ -978,7 +763,24 @@ ahd_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT1_parse_table[] = {
+	{ "CLRREQINIT",		0x01, 0x01 },
+	{ "CLRSTRB2FAST",	0x02, 0x02 },
+	{ "CLRSCSIPERR",	0x04, 0x04 },
+	{ "CLRBUSFREE",		0x08, 0x08 },
+	{ "CLRSCSIRSTI",	0x20, 0x20 },
+	{ "CLRATNO",		0x40, 0x40 },
+	{ "CLRSELTIMEO",	0x80, 0x80 }
+};
+
+int
+ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
+	    0x4c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "BUSFREE_LQO",	0x40, 0xc0 },
 	{ "BUSFREE_DFF0",	0x80, 0xc0 },
 	{ "BUSFREE_DFF1",	0xc0, 0xc0 },
@@ -998,20 +800,7 @@ ahd_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE2_parse_table[] = {
-	{ "ENDMADONE",		0x01, 0x01 },
-	{ "ENSDONE",		0x02, 0x02 },
-	{ "ENWIDE_RES",		0x04, 0x04 }
-};
-
-int
-ahd_simode2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SIMODE2_parse_table, 3, "SIMODE2",
-	    0x4d, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRSINT2_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT2_parse_table[] = {
 	{ "CLRDMADONE",		0x01, 0x01 },
 	{ "CLRSDONE",		0x02, 0x02 },
 	{ "CLRWIDE_RES",	0x04, 0x04 },
@@ -1025,7 +814,7 @@ ahd_clrsint2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
+static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
 	{ "DTERR",		0x01, 0x01 },
 	{ "DGFORMERR",		0x02, 0x02 },
 	{ "CRCERR",		0x04, 0x04 },
@@ -1064,7 +853,7 @@ ahd_lqostate_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x4f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
 	{ "LQIATNCMD",		0x01, 0x01 },
 	{ "LQIATNLQ",		0x02, 0x02 },
 	{ "LQIBADLQT",		0x04, 0x04 },
@@ -1080,23 +869,7 @@ ahd_lqistat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQIINT0_parse_table[] = {
-	{ "CLRLQIATNCMD",	0x01, 0x01 },
-	{ "CLRLQIATNLQ",	0x02, 0x02 },
-	{ "CLRLQIBADLQT",	0x04, 0x04 },
-	{ "CLRLQICRCT2",	0x08, 0x08 },
-	{ "CLRLQICRCT1",	0x10, 0x10 },
-	{ "CLRLQIATNQAS",	0x20, 0x20 }
-};
-
-int
-ahd_clrlqiint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQIINT0_parse_table, 6, "CLRLQIINT0",
-	    0x50, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQIMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQIMODE0_parse_table[] = {
 	{ "ENLQIATNCMD",	0x01, 0x01 },
 	{ "ENLQIATNLQ",		0x02, 0x02 },
 	{ "ENLQIBADLQT",	0x04, 0x04 },
@@ -1112,7 +885,23 @@ ahd_lqimode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQIINT0_parse_table[] = {
+	{ "CLRLQIATNCMD",	0x01, 0x01 },
+	{ "CLRLQIATNLQ",	0x02, 0x02 },
+	{ "CLRLQIBADLQT",	0x04, 0x04 },
+	{ "CLRLQICRCT2",	0x08, 0x08 },
+	{ "CLRLQICRCT1",	0x10, 0x10 },
+	{ "CLRLQIATNQAS",	0x20, 0x20 }
+};
+
+int
+ahd_clrlqiint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(CLRLQIINT0_parse_table, 6, "CLRLQIINT0",
+	    0x50, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
 	{ "ENLQIOVERI_NLQ",	0x01, 0x01 },
 	{ "ENLQIOVERI_LQ",	0x02, 0x02 },
 	{ "ENLQIBADLQI",	0x04, 0x04 },
@@ -1130,7 +919,7 @@ ahd_lqimode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
 	{ "LQIOVERI_NLQ",	0x01, 0x01 },
 	{ "LQIOVERI_LQ",	0x02, 0x02 },
 	{ "LQIBADLQI",		0x04, 0x04 },
@@ -1148,7 +937,7 @@ ahd_lqistat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
 	{ "CLRLQIOVERI_NLQ",	0x01, 0x01 },
 	{ "CLRLQIOVERI_LQ",	0x02, 0x02 },
 	{ "CLRLQIBADLQI",	0x04, 0x04 },
@@ -1166,7 +955,7 @@ ahd_clrlqiint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
 	{ "LQIGSAVAIL",		0x01, 0x01 },
 	{ "LQISTOPCMD",		0x02, 0x02 },
 	{ "LQISTOPLQ",		0x04, 0x04 },
@@ -1184,7 +973,7 @@ ahd_lqistat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x52, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OSRAMPERR",		0x01, 0x01 },
 	{ "NTRAMPERR",		0x02, 0x02 }
 };
@@ -1196,7 +985,7 @@ ahd_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
 	{ "ENOSRAMPERR",	0x01, 0x01 },
 	{ "ENNTRAMPERR",	0x02, 0x02 }
 };
@@ -1208,7 +997,7 @@ ahd_simode3_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
 	{ "CLROSRAMPERR",	0x01, 0x01 },
 	{ "CLRNTRAMPERR",	0x02, 0x02 }
 };
@@ -1220,7 +1009,7 @@ ahd_clrsint3_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
 	{ "LQOTCRC",		0x01, 0x01 },
 	{ "LQOATNPKT",		0x02, 0x02 },
 	{ "LQOATNLQ",		0x04, 0x04 },
@@ -1235,7 +1024,7 @@ ahd_lqostat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
 	{ "CLRLQOTCRC",		0x01, 0x01 },
 	{ "CLRLQOATNPKT",	0x02, 0x02 },
 	{ "CLRLQOATNLQ",	0x04, 0x04 },
@@ -1250,7 +1039,7 @@ ahd_clrlqoint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
 	{ "ENLQOTCRC",		0x01, 0x01 },
 	{ "ENLQOATNPKT",	0x02, 0x02 },
 	{ "ENLQOATNLQ",		0x04, 0x04 },
@@ -1265,7 +1054,7 @@ ahd_lqomode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
 	{ "ENLQOPHACHGINPKT",	0x01, 0x01 },
 	{ "ENLQOBUSFREE",	0x02, 0x02 },
 	{ "ENLQOBADQAS",	0x04, 0x04 },
@@ -1280,7 +1069,7 @@ ahd_lqomode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
 	{ "LQOPHACHGINPKT",	0x01, 0x01 },
 	{ "LQOBUSFREE",		0x02, 0x02 },
 	{ "LQOBADQAS",		0x04, 0x04 },
@@ -1295,7 +1084,7 @@ ahd_lqostat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
 	{ "CLRLQOPHACHGINPKT",	0x01, 0x01 },
 	{ "CLRLQOBUSFREE",	0x02, 0x02 },
 	{ "CLRLQOBADQAS",	0x04, 0x04 },
@@ -1310,7 +1099,7 @@ ahd_clrlqoint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
 	{ "LQOSTOP0",		0x01, 0x01 },
 	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
 	{ "LQOWAITFIFO",	0x10, 0x10 },
@@ -1331,7 +1120,7 @@ ahd_os_space_cnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x56, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENSTRB2FAST",	0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
@@ -1356,7 +1145,7 @@ ahd_gsfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x58, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
 	{ "RSTCHN",		0x01, 0x01 },
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "CLRSHCNT",		0x04, 0x04 },
@@ -1370,15 +1159,17 @@ ahd_dffsxfrctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
 	{ "LQONOCHKOVER",	0x01, 0x01 },
+	{ "LQONOHOLDLACK",	0x02, 0x02 },
+	{ "LQOBUSETDLY",	0x40, 0x40 },
 	{ "LQOH2A_VERSION",	0x80, 0x80 }
 };
 
 int
 ahd_lqoscsctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(LQOSCSCTL_parse_table, 2, "LQOSCSCTL",
+	return (ahd_print_register(LQOSCSCTL_parse_table, 4, "LQOSCSCTL",
 	    0x5a, regvalue, cur_col, wrap));
 }
 
@@ -1389,7 +1180,7 @@ ahd_nextscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
+static const ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
 	{ "CLRCFG4TCMD",	0x01, 0x01 },
 	{ "CLRCFG4ICMD",	0x02, 0x02 },
 	{ "CLRCFG4TSTAT",	0x04, 0x04 },
@@ -1406,7 +1197,7 @@ ahd_clrseqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
 	{ "CFG4TCMD",		0x01, 0x01 },
 	{ "CFG4ICMD",		0x02, 0x02 },
 	{ "CFG4TSTAT",		0x04, 0x04 },
@@ -1423,14 +1214,7 @@ ahd_seqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5b, regvalue, cur_col, wrap));
 }
 
-int
-ahd_currscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CURRSCB",
-	    0x5c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQIMODE_parse_table[] = {
 	{ "ENCFG4TCMD",		0x01, 0x01 },
 	{ "ENCFG4ICMD",		0x02, 0x02 },
 	{ "ENCFG4TSTAT",	0x04, 0x04 },
@@ -1447,7 +1231,14 @@ ahd_seqimode_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
+int
+ahd_currscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
+{
+	return (ahd_print_register(NULL, 0, "CURRSCB",
+	    0x5c, regvalue, cur_col, wrap));
+}
+
+static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
 	{ "FIFOFREE",		0x01, 0x01 },
 	{ "DATAINFIFO",		0x02, 0x02 },
 	{ "DLZERO",		0x04, 0x04 },
@@ -1464,24 +1255,6 @@ ahd_mdffstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CRCCONTROL_parse_table[] = {
-	{ "CRCVALCHKEN",	0x40, 0x40 }
-};
-
-int
-ahd_crccontrol_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CRCCONTROL_parse_table, 1, "CRCCONTROL",
-	    0x5d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfftag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFFTAG",
-	    0x5e, regvalue, cur_col, wrap));
-}
-
 int
 ahd_lastscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1489,31 +1262,6 @@ ahd_lastscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSITEST_parse_table[] = {
-	{ "SEL_TXPLL_DEBUG",	0x04, 0x04 },
-	{ "CNTRTEST",		0x08, 0x08 }
-};
-
-int
-ahd_scsitest_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSITEST_parse_table, 2, "SCSITEST",
-	    0x5e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t IOPDNCTL_parse_table[] = {
-	{ "PDN_DIFFSENSE",	0x01, 0x01 },
-	{ "PDN_IDIST",		0x04, 0x04 },
-	{ "DISABLE_OE",		0x80, 0x80 }
-};
-
-int
-ahd_iopdnctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(IOPDNCTL_parse_table, 3, "IOPDNCTL",
-	    0x5f, regvalue, cur_col, wrap));
-}
-
 int
 ahd_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1529,13 +1277,6 @@ ahd_negoaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_dgrpcrci_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DGRPCRCI",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
 ahd_negperiod_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "NEGPERIOD",
@@ -1543,20 +1284,13 @@ ahd_negperiod_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_packcrci_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PACKCRCI",
-	    0x62, regvalue, cur_col, wrap));
-}
-
-int
 ahd_negoffset_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "NEGOFFSET",
 	    0x62, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
+static const ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
 	{ "PPROPT_IUT",		0x01, 0x01 },
 	{ "PPROPT_DT",		0x02, 0x02 },
 	{ "PPROPT_QAS",		0x04, 0x04 },
@@ -1570,7 +1304,7 @@ ahd_negppropts_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x63, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
+static const ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
 	{ "WIDEXFER",		0x01, 0x01 },
 	{ "ENAUTOATNO",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
@@ -1601,20 +1335,21 @@ ahd_annexdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x66, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
 	{ "LSTSGCLRDIS",	0x01, 0x01 },
 	{ "SHVALIDSTDIS",	0x02, 0x02 },
 	{ "DFFACTCLR",		0x04, 0x04 },
 	{ "SDONEMSKDIS",	0x08, 0x08 },
 	{ "WIDERESEN",		0x10, 0x10 },
 	{ "CURRFIFODEF",	0x20, 0x20 },
-	{ "STSELSKIDDIS",	0x40, 0x40 }
+	{ "STSELSKIDDIS",	0x40, 0x40 },
+	{ "BIDICHKDIS",		0x80, 0x80 }
 };
 
 int
 ahd_scschkn_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(SCSCHKN_parse_table, 7, "SCSCHKN",
+	return (ahd_print_register(SCSCHKN_parse_table, 8, "SCSCHKN",
 	    0x66, regvalue, cur_col, wrap));
 }
 
@@ -1625,23 +1360,6 @@ ahd_iownid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x67, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL960CTL0_parse_table[] = {
-	{ "PLL_ENFBM",		0x01, 0x01 },
-	{ "PLL_DLPF",		0x02, 0x02 },
-	{ "PLL_ENLPF",		0x04, 0x04 },
-	{ "PLL_ENLUD",		0x08, 0x08 },
-	{ "PLL_NS",		0x30, 0x30 },
-	{ "PLL_PWDN",		0x40, 0x40 },
-	{ "PLL_VCOSEL",		0x80, 0x80 }
-};
-
-int
-ahd_pll960ctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PLL960CTL0_parse_table, 7, "PLL960CTL0",
-	    0x68, regvalue, cur_col, wrap));
-}
-
 int
 ahd_shcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1656,33 +1374,6 @@ ahd_townid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x69, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL960CTL1_parse_table[] = {
-	{ "PLL_RST",		0x01, 0x01 },
-	{ "PLL_CNTCLR",		0x40, 0x40 },
-	{ "PLL_CNTEN",		0x80, 0x80 }
-};
-
-int
-ahd_pll960ctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PLL960CTL1_parse_table, 3, "PLL960CTL1",
-	    0x69, regvalue, cur_col, wrap));
-}
-
-int
-ahd_pll960cnt0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PLL960CNT0",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_xsig_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "XSIG",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
 int
 ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1690,57 +1381,6 @@ ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x6b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLL400CTL0_parse_table[] = {
-	{ "PLL_ENFBM",		0x01, 0x01 },
-	{ "PLL_DLPF",		0x02, 0x02 },
-	{ "PLL_ENLPF",		0x04, 0x04 },
-	{ "PLL_ENLUD",		0x08, 0x08 },
-	{ "PLL_NS",		0x30, 0x30 },
-	{ "PLL_PWDN",		0x40, 0x40 },
-	{ "PLL_VCOSEL",		0x80, 0x80 }
-};
-
-int
-ahd_pll400ctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PLL400CTL0_parse_table, 7, "PLL400CTL0",
-	    0x6c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_fairness_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FAIRNESS",
-	    0x6c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t PLL400CTL1_parse_table[] = {
-	{ "PLL_RST",		0x01, 0x01 },
-	{ "PLL_CNTCLR",		0x40, 0x40 },
-	{ "PLL_CNTEN",		0x80, 0x80 }
-};
-
-int
-ahd_pll400ctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PLL400CTL1_parse_table, 3, "PLL400CTL1",
-	    0x6d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_unfairness_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "UNFAIRNESS",
-	    0x6e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_pll400cnt0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PLL400CNT0",
-	    0x6e, regvalue, cur_col, wrap));
-}
-
 int
 ahd_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1748,31 +1388,6 @@ ahd_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x70, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t PLLDELAY_parse_table[] = {
-	{ "SPLIT_DROP_REQ",	0x80, 0x80 }
-};
-
-int
-ahd_plldelay_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PLLDELAY_parse_table, 1, "PLLDELAY",
-	    0x70, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hodmaadr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HODMAADR",
-	    0x70, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hodmacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HODMACNT",
-	    0x78, regvalue, cur_col, wrap));
-}
-
 int
 ahd_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -1781,10 +1396,10 @@ ahd_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_hodmaen_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_sghaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "HODMAEN",
-	    0x7a, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SGHADDR",
+	    0x7c, regvalue, cur_col, wrap));
 }
 
 int
@@ -1795,10 +1410,10 @@ ahd_scbhaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_sghaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_sghcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SGHADDR",
-	    0x7c, regvalue, cur_col, wrap));
+	return (ahd_print_register(NULL, 0, "SGHCNT",
+	    0x84, regvalue, cur_col, wrap));
 }
 
 int
@@ -1808,14 +1423,7 @@ ahd_scbhcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x84, regvalue, cur_col, wrap));
 }
 
-int
-ahd_sghcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SGHCNT",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
+static const ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
 	{ "WR_DFTHRSH_MIN",	0x00, 0x70 },
 	{ "RD_DFTHRSH_MIN",	0x00, 0x07 },
 	{ "RD_DFTHRSH_25",	0x01, 0x07 },
@@ -1843,209 +1451,7 @@ ahd_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x88, regvalue, cur_col, wrap));
 }
 
-int
-ahd_romaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ROMADDR",
-	    0x8a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t ROMCNTRL_parse_table[] = {
-	{ "RDY",		0x01, 0x01 },
-	{ "REPEAT",		0x02, 0x02 },
-	{ "ROMSPD",		0x18, 0x18 },
-	{ "ROMOP",		0xe0, 0xe0 }
-};
-
-int
-ahd_romcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ROMCNTRL_parse_table, 4, "ROMCNTRL",
-	    0x8d, regvalue, cur_col, wrap));
-}
-
-int
-ahd_romdata_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ROMDATA",
-	    0x8e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCRXMSG0_parse_table[] = {
-	{ "CFNUM",		0x07, 0x07 },
-	{ "CDNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_cmcrxmsg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCRXMSG0_parse_table, 2, "CMCRXMSG0",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t ROENABLE_parse_table[] = {
-	{ "DCH0ROEN",		0x01, 0x01 },
-	{ "DCH1ROEN",		0x02, 0x02 },
-	{ "SGROEN",		0x04, 0x04 },
-	{ "CMCROEN",		0x08, 0x08 },
-	{ "OVLYROEN",		0x10, 0x10 },
-	{ "MSIROEN",		0x20, 0x20 }
-};
-
-int
-ahd_roenable_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ROENABLE_parse_table, 6, "ROENABLE",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYRXMSG0_parse_table[] = {
-	{ "CFNUM",		0x07, 0x07 },
-	{ "CDNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_ovlyrxmsg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYRXMSG0_parse_table, 2, "OVLYRXMSG0",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHRXMSG0_parse_table[] = {
-	{ "CFNUM",		0x07, 0x07 },
-	{ "CDNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_dchrxmsg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHRXMSG0_parse_table, 2, "DCHRXMSG0",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYRXMSG1_parse_table[] = {
-	{ "CBNUM",		0xff, 0xff }
-};
-
-int
-ahd_ovlyrxmsg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYRXMSG1_parse_table, 1, "OVLYRXMSG1",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t NSENABLE_parse_table[] = {
-	{ "DCH0NSEN",		0x01, 0x01 },
-	{ "DCH1NSEN",		0x02, 0x02 },
-	{ "SGNSEN",		0x04, 0x04 },
-	{ "CMCNSEN",		0x08, 0x08 },
-	{ "OVLYNSEN",		0x10, 0x10 },
-	{ "MSINSEN",		0x20, 0x20 }
-};
-
-int
-ahd_nsenable_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NSENABLE_parse_table, 6, "NSENABLE",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCRXMSG1_parse_table[] = {
-	{ "CBNUM",		0xff, 0xff }
-};
-
-int
-ahd_cmcrxmsg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCRXMSG1_parse_table, 1, "CMCRXMSG1",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHRXMSG1_parse_table[] = {
-	{ "CBNUM",		0xff, 0xff }
-};
-
-int
-ahd_dchrxmsg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHRXMSG1_parse_table, 1, "DCHRXMSG1",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHRXMSG2_parse_table[] = {
-	{ "MINDEX",		0xff, 0xff }
-};
-
-int
-ahd_dchrxmsg2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHRXMSG2_parse_table, 1, "DCHRXMSG2",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCRXMSG2_parse_table[] = {
-	{ "MINDEX",		0xff, 0xff }
-};
-
-int
-ahd_cmcrxmsg2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCRXMSG2_parse_table, 1, "CMCRXMSG2",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ost_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "OST",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYRXMSG2_parse_table[] = {
-	{ "MINDEX",		0xff, 0xff }
-};
-
-int
-ahd_ovlyrxmsg2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYRXMSG2_parse_table, 1, "OVLYRXMSG2",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHRXMSG3_parse_table[] = {
-	{ "MCLASS",		0x0f, 0x0f }
-};
-
-int
-ahd_dchrxmsg3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHRXMSG3_parse_table, 1, "DCHRXMSG3",
-	    0x93, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYRXMSG3_parse_table[] = {
-	{ "MCLASS",		0x0f, 0x0f }
-};
-
-int
-ahd_ovlyrxmsg3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYRXMSG3_parse_table, 1, "OVLYRXMSG3",
-	    0x93, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCRXMSG3_parse_table[] = {
-	{ "MCLASS",		0x0f, 0x0f }
-};
-
-int
-ahd_cmcrxmsg3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCRXMSG3_parse_table, 1, "CMCRXMSG3",
-	    0x93, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t PCIXCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t PCIXCTL_parse_table[] = {
 	{ "CMPABCDIS",		0x01, 0x01 },
 	{ "TSCSERREN",		0x02, 0x02 },
 	{ "SRSPDPEEN",		0x04, 0x04 },
@@ -2062,46 +1468,7 @@ ahd_pcixctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x93, regvalue, cur_col, wrap));
 }
 
-int
-ahd_ovlyseqbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "OVLYSEQBCNT",
-	    0x94, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dchseqbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DCHSEQBCNT",
-	    0x94, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmcseqbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMCSEQBCNT",
-	    0x94, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCSPLTSTAT0_parse_table[] = {
-	{ "RXSPLTRSP",		0x01, 0x01 },
-	{ "RXSCEMSG",		0x02, 0x02 },
-	{ "RXOVRUN",		0x04, 0x04 },
-	{ "CNTNOTCMPLT",	0x08, 0x08 },
-	{ "SCDATBUCKET",	0x10, 0x10 },
-	{ "SCADERR",		0x20, 0x20 },
-	{ "SCBCERR",		0x40, 0x40 },
-	{ "STAETERM",		0x80, 0x80 }
-};
-
-int
-ahd_cmcspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCSPLTSTAT0_parse_table, 8, "CMCSPLTSTAT0",
-	    0x96, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2119,47 +1486,7 @@ ahd_dchspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x96, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OVLYSPLTSTAT0_parse_table[] = {
-	{ "RXSPLTRSP",		0x01, 0x01 },
-	{ "RXSCEMSG",		0x02, 0x02 },
-	{ "RXOVRUN",		0x04, 0x04 },
-	{ "CNTNOTCMPLT",	0x08, 0x08 },
-	{ "SCDATBUCKET",	0x10, 0x10 },
-	{ "SCADERR",		0x20, 0x20 },
-	{ "SCBCERR",		0x40, 0x40 },
-	{ "STAETERM",		0x80, 0x80 }
-};
-
-int
-ahd_ovlyspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYSPLTSTAT0_parse_table, 8, "OVLYSPLTSTAT0",
-	    0x96, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCSPLTSTAT1_parse_table[] = {
-	{ "RXDATABUCKET",	0x01, 0x01 }
-};
-
-int
-ahd_cmcspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCSPLTSTAT1_parse_table, 1, "CMCSPLTSTAT1",
-	    0x97, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYSPLTSTAT1_parse_table[] = {
-	{ "RXDATABUCKET",	0x01, 0x01 }
-};
-
-int
-ahd_ovlyspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYSPLTSTAT1_parse_table, 1, "OVLYSPLTSTAT1",
-	    0x97, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DCHSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t DCHSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2170,139 +1497,7 @@ ahd_dchspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x97, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGRXMSG0_parse_table[] = {
-	{ "CFNUM",		0x07, 0x07 },
-	{ "CDNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_sgrxmsg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGRXMSG0_parse_table, 2, "SGRXMSG0",
-	    0x98, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTADR0_parse_table[] = {
-	{ "LOWER_ADDR",		0x7f, 0x7f }
-};
-
-int
-ahd_slvspltoutadr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTADR0_parse_table, 1, "SLVSPLTOUTADR0",
-	    0x98, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGRXMSG1_parse_table[] = {
-	{ "CBNUM",		0xff, 0xff }
-};
-
-int
-ahd_sgrxmsg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGRXMSG1_parse_table, 1, "SGRXMSG1",
-	    0x99, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTADR1_parse_table[] = {
-	{ "REQ_FNUM",		0x07, 0x07 },
-	{ "REQ_DNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_slvspltoutadr1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTADR1_parse_table, 2, "SLVSPLTOUTADR1",
-	    0x99, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGRXMSG2_parse_table[] = {
-	{ "MINDEX",		0xff, 0xff }
-};
-
-int
-ahd_sgrxmsg2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGRXMSG2_parse_table, 1, "SGRXMSG2",
-	    0x9a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTADR2_parse_table[] = {
-	{ "REQ_BNUM",		0xff, 0xff }
-};
-
-int
-ahd_slvspltoutadr2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTADR2_parse_table, 1, "SLVSPLTOUTADR2",
-	    0x9a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGRXMSG3_parse_table[] = {
-	{ "MCLASS",		0x0f, 0x0f }
-};
-
-int
-ahd_sgrxmsg3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGRXMSG3_parse_table, 1, "SGRXMSG3",
-	    0x9b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTADR3_parse_table[] = {
-	{ "RLXORD",		0x10, 0x10 },
-	{ "TAG_NUM",		0x1f, 0x1f }
-};
-
-int
-ahd_slvspltoutadr3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTADR3_parse_table, 2, "SLVSPLTOUTADR3",
-	    0x9b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sgseqbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SGSEQBCNT",
-	    0x9c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR0_parse_table[] = {
-	{ "LOWER_BCNT",		0xff, 0xff }
-};
-
-int
-ahd_slvspltoutattr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTATTR0_parse_table, 1, "SLVSPLTOUTATTR0",
-	    0x9c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR1_parse_table[] = {
-	{ "CMPLT_FNUM",		0x07, 0x07 },
-	{ "CMPLT_DNUM",		0xf8, 0xf8 }
-};
-
-int
-ahd_slvspltoutattr1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTATTR1_parse_table, 2, "SLVSPLTOUTATTR1",
-	    0x9d, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SLVSPLTOUTATTR2_parse_table[] = {
-	{ "CMPLT_BNUM",		0xff, 0xff }
-};
-
-int
-ahd_slvspltoutattr2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SLVSPLTOUTATTR2_parse_table, 1, "SLVSPLTOUTATTR2",
-	    0x9e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGSPLTSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t SGSPLTSTAT0_parse_table[] = {
 	{ "RXSPLTRSP",		0x01, 0x01 },
 	{ "RXSCEMSG",		0x02, 0x02 },
 	{ "RXOVRUN",		0x04, 0x04 },
@@ -2320,7 +1515,7 @@ ahd_sgspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
 	{ "RXDATABUCKET",	0x01, 0x01 }
 };
 
@@ -2331,19 +1526,7 @@ ahd_sgspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x9f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SFUNCT_parse_table[] = {
-	{ "TEST_NUM",		0x0f, 0x0f },
-	{ "TEST_GROUP",		0xf0, 0xf0 }
-};
-
-int
-ahd_sfunct_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SFUNCT_parse_table, 2, "SFUNCT",
-	    0x9f, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DF0PCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t DF0PCISTAT_parse_table[] = {
 	{ "DPR",		0x01, 0x01 },
 	{ "TWATERR",		0x02, 0x02 },
 	{ "RDPERR",		0x04, 0x04 },
@@ -2368,83 +1551,6 @@ ahd_reg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xa0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DF1PCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "TWATERR",		0x02, 0x02 },
-	{ "RDPERR",		0x04, 0x04 },
-	{ "SCAAPERR",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_df1pcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DF1PCISTAT_parse_table, 8, "DF1PCISTAT",
-	    0xa1, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGPCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "RDPERR",		0x04, 0x04 },
-	{ "SCAAPERR",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_sgpcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGPCISTAT_parse_table, 7, "SGPCISTAT",
-	    0xa2, regvalue, cur_col, wrap));
-}
-
-int
-ahd_reg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "REG1",
-	    0xa2, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CMCPCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "TWATERR",		0x02, 0x02 },
-	{ "RDPERR",		0x04, 0x04 },
-	{ "SCAAPERR",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_cmcpcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMCPCISTAT_parse_table, 8, "CMCPCISTAT",
-	    0xa3, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t OVLYPCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "RDPERR",		0x04, 0x04 },
-	{ "SCAAPERR",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_ovlypcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OVLYPCISTAT_parse_table, 7, "OVLYPCISTAT",
-	    0xa4, regvalue, cur_col, wrap));
-}
-
 int
 ahd_reg_isr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -2452,7 +1558,7 @@ ahd_reg_isr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xa4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
 	{ "SEGS_AVAIL",		0x01, 0x01 },
 	{ "LOADING_NEEDED",	0x02, 0x02 },
 	{ "FETCH_INPROG",	0x04, 0x04 }
@@ -2465,23 +1571,7 @@ ahd_sg_state_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xa6, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t MSIPCISTAT_parse_table[] = {
-	{ "DPR",		0x01, 0x01 },
-	{ "TWATERR",		0x02, 0x02 },
-	{ "CLRPENDMSI",		0x08, 0x08 },
-	{ "RTA",		0x10, 0x10 },
-	{ "RMA",		0x20, 0x20 },
-	{ "SSE",		0x40, 0x40 }
-};
-
-int
-ahd_msipcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(MSIPCISTAT_parse_table, 6, "MSIPCISTAT",
-	    0xa6, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
 	{ "TWATERR",		0x02, 0x02 },
 	{ "STA",		0x08, 0x08 },
 	{ "SSE",		0x40, 0x40 },
@@ -2496,27 +1586,13 @@ ahd_targpcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_data_count_odd_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DATA_COUNT_ODD",
-	    0xa7, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCBPTR",
 	    0xa8, regvalue, cur_col, wrap));
 }
 
-int
-ahd_ccscbacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBACNT",
-	    0xab, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
 	{ "SCBPTR_OFF",		0x07, 0x07 },
 	{ "SCBPTR_ADDR",	0x38, 0x38 },
 	{ "AUSCBPTR_EN",	0x80, 0x80 }
@@ -2537,36 +1613,13 @@ ahd_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_ccscbadr_bk_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBADR_BK",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-int
 ahd_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "CCSCBADDR",
 	    0xac, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CMC_RAMBIST_parse_table[] = {
-	{ "CMC_BUFFER_BIST_EN",	0x01, 0x01 },
-	{ "CMC_BUFFER_BIST_FAIL",0x02, 0x02 },
-	{ "SG_BIST_EN",		0x10, 0x10 },
-	{ "SG_BIST_FAIL",	0x20, 0x20 },
-	{ "SCBRAMBIST_FAIL",	0x40, 0x40 },
-	{ "SG_ELEMENT_SIZE",	0x80, 0x80 }
-};
-
-int
-ahd_cmc_rambist_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CMC_RAMBIST_parse_table, 6, "CMC_RAMBIST",
-	    0xad, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t CCSCBCTL_parse_table[] = {
 	{ "CCSCBRESET",		0x01, 0x01 },
 	{ "CCSCBDIR",		0x04, 0x04 },
 	{ "CCSCBEN",		0x08, 0x08 },
@@ -2582,7 +1635,7 @@ ahd_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xad, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGRESET",		0x01, 0x01 },
 	{ "SG_FETCH_REQ",	0x02, 0x02 },
 	{ "CCSGENACK",		0x08, 0x08 },
@@ -2606,13 +1659,6 @@ ahd_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_flexadr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLEXADR",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
 ahd_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "CCSCBRAM",
@@ -2620,39 +1666,13 @@ ahd_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_flexcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLEXCNT",
-	    0xb3, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t FLEXDMASTAT_parse_table[] = {
-	{ "FLEXDMADONE",	0x01, 0x01 },
-	{ "FLEXDMAERR",		0x02, 0x02 }
-};
-
-int
-ahd_flexdmastat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(FLEXDMASTAT_parse_table, 2, "FLEXDMASTAT",
-	    0xb5, regvalue, cur_col, wrap));
-}
-
-int
-ahd_flexdata_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLEXDATA",
-	    0xb6, regvalue, cur_col, wrap));
-}
-
-int
 ahd_brddat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "BRDDAT",
 	    0xb8, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
 	{ "BRDSTB",		0x01, 0x01 },
 	{ "BRDRW",		0x02, 0x02 },
 	{ "BRDEN",		0x04, 0x04 },
@@ -2682,7 +1702,7 @@ ahd_seedat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xbc, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEECTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SEECTL_parse_table[] = {
 	{ "SEEOP_ERAL",		0x40, 0x70 },
 	{ "SEEOP_WRITE",	0x50, 0x70 },
 	{ "SEEOP_READ",		0x60, 0x70 },
@@ -2702,7 +1722,7 @@ ahd_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xbe, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
 	{ "SEESTART",		0x01, 0x01 },
 	{ "SEEBUSY",		0x02, 0x02 },
 	{ "SEEARBACK",		0x04, 0x04 },
@@ -2718,34 +1738,7 @@ ahd_seestat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xbe, regvalue, cur_col, wrap));
 }
 
-int
-ahd_scbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCBCNT",
-	    0xbf, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfwaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFWADDR",
-	    0xc0, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSPFLTRCTL_parse_table[] = {
-	{ "DSPFCNTSEL",		0x0f, 0x0f },
-	{ "EDGESENSE",		0x10, 0x10 },
-	{ "FLTRDISABLE",	0x20, 0x20 }
-};
-
-int
-ahd_dspfltrctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPFLTRCTL_parse_table, 3, "DSPFLTRCTL",
-	    0xc0, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSPDATACTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPDATACTL_parse_table[] = {
 	{ "XMITOFFSTDIS",	0x02, 0x02 },
 	{ "RCVROFFSTDIS",	0x04, 0x04 },
 	{ "DESQDIS",		0x10, 0x10 },
@@ -2760,44 +1753,13 @@ ahd_dspdatactl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_dfraddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFRADDR",
-	    0xc2, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSPREQCTL_parse_table[] = {
-	{ "MANREQDLY",		0x3f, 0x3f },
-	{ "MANREQCTL",		0xc0, 0xc0 }
-};
-
-int
-ahd_dspreqctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPREQCTL_parse_table, 2, "DSPREQCTL",
-	    0xc2, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSPACKCTL_parse_table[] = {
-	{ "MANACKDLY",		0x3f, 0x3f },
-	{ "MANACKCTL",		0xc0, 0xc0 }
-};
-
-int
-ahd_dspackctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPACKCTL_parse_table, 2, "DSPACKCTL",
-	    0xc3, regvalue, cur_col, wrap));
-}
-
-int
 ahd_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "DFDAT",
 	    0xc4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
+static const ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
 	{ "DSPSEL",		0x1f, 0x1f },
 	{ "AUTOINCEN",		0x80, 0x80 }
 };
@@ -2809,7 +1771,7 @@ ahd_dspselect_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xc4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
 	{ "XMITMANVAL",		0x3f, 0x3f },
 	{ "AUTOXBCDIS",		0x80, 0x80 }
 };
@@ -2821,91 +1783,7 @@ ahd_wrtbiasctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xc5, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t RCVRBIOSCTL_parse_table[] = {
-	{ "RCVRMANVAL",		0x3f, 0x3f },
-	{ "AUTORBCDIS",		0x80, 0x80 }
-};
-
-int
-ahd_rcvrbiosctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(RCVRBIOSCTL_parse_table, 2, "RCVRBIOSCTL",
-	    0xc6, regvalue, cur_col, wrap));
-}
-
-int
-ahd_wrtbiascalc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "WRTBIASCALC",
-	    0xc7, regvalue, cur_col, wrap));
-}
-
-int
-ahd_rcvrbiascalc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "RCVRBIASCALC",
-	    0xc8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfptrs_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFPTRS",
-	    0xc8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_skewcalc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SKEWCALC",
-	    0xc9, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfbkptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFBKPTR",
-	    0xc9, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFDBCTL_parse_table[] = {
-	{ "DFF_RAMBIST_EN",	0x01, 0x01 },
-	{ "DFF_RAMBIST_DONE",	0x02, 0x02 },
-	{ "DFF_RAMBIST_FAIL",	0x04, 0x04 },
-	{ "DFF_DIR_ERR",	0x08, 0x08 },
-	{ "DFF_CIO_RD_RDY",	0x10, 0x10 },
-	{ "DFF_CIO_WR_RDY",	0x20, 0x20 }
-};
-
-int
-ahd_dfdbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFDBCTL_parse_table, 6, "DFDBCTL",
-	    0xcb, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfscnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFSCNT",
-	    0xcc, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dfbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFBCNT",
-	    0xce, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ovlyaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "OVLYADDR",
-	    0xd4, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQCTL0_parse_table[] = {
 	{ "LOADRAM",		0x01, 0x01 },
 	{ "SEQRESET",		0x02, 0x02 },
 	{ "STEP",		0x04, 0x04 },
@@ -2923,21 +1801,7 @@ ahd_seqctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xd6, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQCTL1_parse_table[] = {
-	{ "RAMBIST_EN",		0x01, 0x01 },
-	{ "RAMBIST_FAIL",	0x02, 0x02 },
-	{ "RAMBIST_DONE",	0x04, 0x04 },
-	{ "OVRLAY_DATA_CHK",	0x08, 0x08 }
-};
-
-int
-ahd_seqctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQCTL1_parse_table, 4, "SEQCTL1",
-	    0xd7, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t FLAGS_parse_table[] = {
+static const ahd_reg_parse_entry_t FLAGS_parse_table[] = {
 	{ "CARRY",		0x01, 0x01 },
 	{ "ZERO",		0x02, 0x02 }
 };
@@ -2949,7 +1813,7 @@ ahd_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xd8, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
 	{ "IRET",		0x01, 0x01 },
 	{ "INTMASK1",		0x02, 0x02 },
 	{ "INTMASK2",		0x04, 0x04 },
@@ -3002,24 +1866,6 @@ ahd_dindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_brkaddr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "BRKADDR0",
-	    0xe6, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t BRKADDR1_parse_table[] = {
-	{ "BRKDIS",		0x80, 0x80 }
-};
-
-int
-ahd_brkaddr1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(BRKADDR1_parse_table, 1, "BRKADDR1",
-	    0xe6, regvalue, cur_col, wrap));
-}
-
-int
 ahd_allones_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "ALLONES",
@@ -3055,13 +1901,6 @@ ahd_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_function1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FUNCTION1",
-	    0xf0, regvalue, cur_col, wrap));
-}
-
-int
 ahd_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "STACK",
@@ -3083,13 +1922,6 @@ ahd_curaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_lastaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LASTADDR",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
 ahd_intvec2_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "INTVEC2_ADDR",
@@ -3111,23 +1943,16 @@ ahd_accum_save_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_waiting_scb_tails_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "WAITING_SCB_TAILS",
-	    0x100, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ahd_pci_config_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "AHD_PCI_CONFIG_BASE",
+	return (ahd_print_register(NULL, 0, "SRAM_BASE",
 	    0x100, regvalue, cur_col, wrap));
 }
 
 int
-ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_waiting_scb_tails_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SRAM_BASE",
+	return (ahd_print_register(NULL, 0, "WAITING_SCB_TAILS",
 	    0x100, regvalue, cur_col, wrap));
 }
 
@@ -3215,7 +2040,7 @@ ahd_msg_out_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x137, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -3235,7 +2060,7 @@ ahd_dmaparams_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x138, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
@@ -3268,7 +2093,7 @@ ahd_saved_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x13b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
@@ -3326,7 +2151,7 @@ ahd_qoutfifo_next_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x144, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahd_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_MSG_LOOP_TARG",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP_READ",	0x03, 0x03 },
 	{ "CONT_MSG_LOOP_WRITE",0x04, 0x04 },
@@ -3358,7 +2183,7 @@ ahd_last_msg_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x14a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
@@ -3381,7 +2206,7 @@ ahd_initiator_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x14c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
 	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
@@ -3465,20 +2290,20 @@ ahd_mk_message_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_scb_residual_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SCB_BASE",
+	return (ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT",
 	    0x180, regvalue, cur_col, wrap));
 }
 
 int
-ahd_scb_residual_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
+ahd_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
-	return (ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT",
+	return (ahd_print_register(NULL, 0, "SCB_BASE",
 	    0x180, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_OVERRUN_RESID",	0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -3499,27 +2324,6 @@ ahd_scb_scsi_status_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_scb_target_phases_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_TARGET_PHASES",
-	    0x189, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_target_data_dir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_TARGET_DATA_DIR",
-	    0x18a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scb_target_itag_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_TARGET_ITAG",
-	    0x18b, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scb_sense_busaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCB_SENSE_BUSADDR",
@@ -3533,7 +2337,7 @@ ahd_scb_tag_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x190, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "SCB_TAG_TYPE",	0x03, 0x03 },
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "STATUS_RCVD",	0x08, 0x08 },
@@ -3550,7 +2354,7 @@ ahd_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x192, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "OID",		0x0f, 0x0f },
 	{ "TID",		0xf0, 0xf0 }
 };
@@ -3562,7 +2366,7 @@ ahd_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x193, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "LID",		0xff, 0xff }
 };
 
@@ -3573,7 +2377,7 @@ ahd_scb_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x194, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x01, 0x01 }
 };
 
@@ -3584,7 +2388,7 @@ ahd_scb_task_attribute_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x195, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
 	{ "SCB_CDB_LEN_PTR",	0x80, 0x80 }
 };
 
@@ -3609,7 +2413,7 @@ ahd_scb_dataptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x198, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f },
 	{ "SG_LAST_SEG",	0x80, 0x80 }
 };
@@ -3621,7 +2425,7 @@ ahd_scb_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1a0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_STATUS_VALID",	0x04, 0x04 }
@@ -3656,13 +2460,6 @@ ahd_scb_next2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahd_scb_spare_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCB_SPARE",
-	    0x1b0, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scb_disconnected_lists_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCB_DISCONNECTED_LISTS",
diff --git a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
index 11bed07..4b51e23 100644
--- a/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
+++ b/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped
@@ -5,7 +5,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xff, 0x02, 0x06, 0x78,
 	0x00, 0xea, 0x6e, 0x59,
 	0x01, 0xea, 0x04, 0x30,
@@ -1027,7 +1027,7 @@ ahd_patch0_func(struct ahd_softc *ahd)
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahd_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
@@ -1166,7 +1166,7 @@ static struct patch {
 	{ ahd_patch23_func, 815, 11, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {
diff --git a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped b/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
index 88bfd76..309a562 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
+++ b/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped
@@ -8,7 +8,7 @@
 
 #include "aic7xxx_osm.h"
 
-static ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
@@ -26,7 +26,7 @@ ahc_scsiseq_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x00, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+static const ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "SCAMEN",		0x04, 0x04 },
 	{ "SPIOEN",		0x08, 0x08 },
@@ -43,7 +43,7 @@ ahc_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
+static const ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
 	{ "STPWEN",		0x01, 0x01 },
 	{ "ACTNEGEN",		0x02, 0x02 },
 	{ "ENSTIMER",		0x04, 0x04 },
@@ -60,7 +60,7 @@ ahc_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x02, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
 	{ "ACKO",		0x01, 0x01 },
 	{ "REQO",		0x02, 0x02 },
 	{ "BSYO",		0x04, 0x04 },
@@ -85,7 +85,7 @@ ahc_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "ACKI",		0x01, 0x01 },
 	{ "REQI",		0x02, 0x02 },
 	{ "BSYI",		0x04, 0x04 },
@@ -112,7 +112,7 @@ ahc_scsisigi_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
 	{ "SINGLE_EDGE",	0x10, 0x10 },
 	{ "ENABLE_CRC",		0x40, 0x40 },
 	{ "WIDEXFER",		0x80, 0x80 },
@@ -128,7 +128,7 @@ ahc_scsirate_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIID_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIID_parse_table[] = {
 	{ "TWIN_CHNLB",		0x80, 0x80 },
 	{ "OID",		0x0f, 0x0f },
 	{ "TWIN_TID",		0x70, 0x70 },
@@ -151,20 +151,13 @@ ahc_scsidatl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_scsidath_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIDATH",
-	    0x07, regvalue, cur_col, wrap));
-}
-
-int
 ahc_stcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "STCNT",
 	    0x08, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
+static const ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
 	{ "DIS_MSGIN_DUALEDGE",	0x01, 0x01 },
 	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
 	{ "SCSIDATL_IMGEN",	0x04, 0x04 },
@@ -190,7 +183,7 @@ ahc_targcrccnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
 	{ "CLRSPIORDY",		0x02, 0x02 },
 	{ "CLRSWRAP",		0x08, 0x08 },
 	{ "CLRIOERR",		0x08, 0x08 },
@@ -206,7 +199,7 @@ ahc_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "DMADONE",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
 	{ "SDONE",		0x04, 0x04 },
@@ -225,7 +218,7 @@ ahc_sstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
 	{ "CLRREQINIT",		0x01, 0x01 },
 	{ "CLRPHASECHG",	0x02, 0x02 },
 	{ "CLRSCSIPERR",	0x04, 0x04 },
@@ -242,7 +235,7 @@ ahc_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "PHASECHG",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
@@ -260,7 +253,7 @@ ahc_sstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "DUAL_EDGE_ERR",	0x01, 0x01 },
 	{ "CRCREQERR",		0x02, 0x02 },
 	{ "CRCENDERR",		0x04, 0x04 },
@@ -278,7 +271,7 @@ ahc_sstat2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OFFCNT",		0x0f, 0x0f },
 	{ "U2OFFCNT",		0x7f, 0x7f },
 	{ "SCSICNT",		0xf0, 0xf0 }
@@ -291,7 +284,7 @@ ahc_sstat3_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
 	{ "OID",		0x0f, 0x0f },
 	{ "TID",		0xf0, 0xf0 }
 };
@@ -303,7 +296,7 @@ ahc_scsiid_ultra2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x0f, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENDMADONE",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENSDONE",		0x04, 0x04 },
@@ -321,7 +314,7 @@ ahc_simode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x10, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENPHASECHG",		0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
@@ -347,33 +340,13 @@ ahc_scsibusl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_scsibush_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIBUSH",
-	    0x13, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SXFRCTL2_parse_table[] = {
-	{ "CMDDMAEN",		0x08, 0x08 },
-	{ "AUTORSTDIS",		0x10, 0x10 },
-	{ "ASYNC_SETUP",	0x07, 0x07 }
-};
-
-int
-ahc_sxfrctl2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SXFRCTL2_parse_table, 3, "SXFRCTL2",
-	    0x13, regvalue, cur_col, wrap));
-}
-
-int
 ahc_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "SHADDR",
 	    0x14, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
+static const ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
 	{ "STAGE1",		0x01, 0x01 },
 	{ "STAGE2",		0x02, 0x02 },
 	{ "STAGE3",		0x04, 0x04 },
@@ -389,7 +362,7 @@ ahc_seltimer_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x18, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SELID_parse_table[] = {
+static const ahc_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
 };
@@ -401,21 +374,6 @@ ahc_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCAMCTL_parse_table[] = {
-	{ "DFLTTID",		0x10, 0x10 },
-	{ "ALTSTIM",		0x20, 0x20 },
-	{ "CLRSCAMSELID",	0x40, 0x40 },
-	{ "ENSCAMSELO",		0x80, 0x80 },
-	{ "SCAMLVL",		0x03, 0x03 }
-};
-
-int
-ahc_scamctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCAMCTL_parse_table, 5, "SCAMCTL",
-	    0x1a, regvalue, cur_col, wrap));
-}
-
 int
 ahc_targid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
@@ -423,7 +381,7 @@ ahc_targid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
+static const ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
 	{ "SSPIOCPS",		0x01, 0x01 },
 	{ "ROM",		0x02, 0x02 },
 	{ "EEPROM",		0x04, 0x04 },
@@ -441,7 +399,7 @@ ahc_spiocap_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
 	{ "BRDCTL0",		0x01, 0x01 },
 	{ "BRDSTB_ULTRA2",	0x01, 0x01 },
 	{ "BRDCTL1",		0x02, 0x02 },
@@ -464,7 +422,7 @@ ahc_brdctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEECTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SEECTL_parse_table[] = {
 	{ "SEEDI",		0x01, 0x01 },
 	{ "SEEDO",		0x02, 0x02 },
 	{ "SEECK",		0x04, 0x04 },
@@ -482,7 +440,7 @@ ahc_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x1e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "XCVR",		0x01, 0x01 },
 	{ "SELWIDE",		0x02, 0x02 },
 	{ "ENAB20",		0x04, 0x04 },
@@ -522,13 +480,6 @@ ahc_disc_dsb_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_cmdsize_table_tail_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CMDSIZE_TABLE_TAIL",
-	    0x34, regvalue, cur_col, wrap));
-}
-
-int
 ahc_mwi_residual_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "MWI_RESIDUAL",
@@ -549,7 +500,7 @@ ahc_msg_out_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -569,7 +520,7 @@ ahc_dmaparams_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
@@ -602,7 +553,7 @@ ahc_saved_lun_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x3e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "MSGI",		0x20, 0x20 },
 	{ "IOI",		0x40, 0x40 },
 	{ "CDI",		0x80, 0x80 },
@@ -645,13 +596,6 @@ ahc_free_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_complete_scbh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "COMPLETE_SCBH",
-	    0x43, regvalue, cur_col, wrap));
-}
-
-int
 ahc_hscb_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "HSCB_ADDR",
@@ -700,7 +644,7 @@ ahc_tqinpos_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahc_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_TARG_SESSION",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP",	0x04, 0x04 },
 	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
@@ -731,7 +675,7 @@ ahc_last_msg_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
 	{ "ENAUTOATNO",		0x08, 0x08 },
@@ -747,7 +691,7 @@ ahc_scsiseq_template_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
 	{ "HA_274_EXTENDED_TRANS",0x01, 0x01 }
 };
 
@@ -758,7 +702,7 @@ ahc_ha_274_biosglobal_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x56, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "SCB_DMA",		0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 }
 };
@@ -770,7 +714,7 @@ ahc_seq_flags2_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x57, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
 	{ "ENSPCHK",		0x20, 0x20 },
 	{ "RESET_SCSI",		0x40, 0x40 },
 	{ "TERM_ENB",		0x80, 0x80 },
@@ -785,7 +729,7 @@ ahc_scsiconf_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t INTDEF_parse_table[] = {
+static const ahc_reg_parse_entry_t INTDEF_parse_table[] = {
 	{ "EDGE_TRIG",		0x80, 0x80 },
 	{ "VECTOR",		0x0f, 0x0f }
 };
@@ -804,7 +748,7 @@ ahc_hostconf_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
 	{ "CHANNEL_B_PRIMARY",	0x08, 0x08 },
 	{ "BIOSMODE",		0x30, 0x30 },
 	{ "BIOSDISABLED",	0x30, 0x30 }
@@ -817,7 +761,7 @@ ahc_ha_274_biosctrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x5f, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
 	{ "LOADRAM",		0x01, 0x01 },
 	{ "SEQRESET",		0x02, 0x02 },
 	{ "STEP",		0x04, 0x04 },
@@ -849,7 +793,7 @@ ahc_seqaddr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x62, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
 	{ "SEQADDR1_MASK",	0x01, 0x01 }
 };
 
@@ -902,7 +846,7 @@ ahc_none_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x6a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t FLAGS_parse_table[] = {
+static const ahc_reg_parse_entry_t FLAGS_parse_table[] = {
 	{ "CARRY",		0x01, 0x01 },
 	{ "ZERO",		0x02, 0x02 }
 };
@@ -929,13 +873,6 @@ ahc_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_function1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "FUNCTION1",
-	    0x6e, regvalue, cur_col, wrap));
-}
-
-int
 ahc_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "STACK",
@@ -956,19 +893,7 @@ ahc_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x70, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BCTL_parse_table[] = {
-	{ "ENABLE",		0x01, 0x01 },
-	{ "ACE",		0x08, 0x08 }
-};
-
-int
-ahc_bctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BCTL_parse_table, 2, "BCTL",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
+static const ahc_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
 	{ "CIOPARCKEN",		0x01, 0x01 },
 	{ "USCBSIZE32",		0x02, 0x02 },
 	{ "RAMPS",		0x04, 0x04 },
@@ -986,7 +911,7 @@ ahc_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x84, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
+static const ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
 	{ "BON",		0x0f, 0x0f },
 	{ "BOFF",		0xf0, 0xf0 }
 };
@@ -998,7 +923,7 @@ ahc_bustime_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x85, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
+static const ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
 	{ "HADDLDSEL0",		0x01, 0x01 },
 	{ "HADDLDSEL1",		0x02, 0x02 },
 	{ "DSLATT",		0xfc, 0xfc }
@@ -1011,7 +936,7 @@ ahc_dscommand1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x85, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
+static const ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
 	{ "STBON",		0x07, 0x07 },
 	{ "STBOFF",		0x38, 0x38 },
 	{ "DFTHRSH_75",		0x80, 0x80 },
@@ -1026,7 +951,7 @@ ahc_busspd_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+static const ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "SEQ_MAILBOX",	0x0f, 0x0f },
 	{ "HOST_TQINPOS",	0x80, 0x80 },
 	{ "HOST_MAILBOX",	0xf0, 0xf0 }
@@ -1039,7 +964,7 @@ ahc_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
+static const ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
 	{ "DFTHRSH_100",	0xc0, 0xc0 }
 };
 
@@ -1050,7 +975,7 @@ ahc_dspcistatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x86, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
 	{ "CHIPRST",		0x01, 0x01 },
 	{ "CHIPRSTACK",		0x01, 0x01 },
 	{ "INTEN",		0x02, 0x02 },
@@ -1088,7 +1013,7 @@ ahc_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x90, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
+static const ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SEQINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
 	{ "SCSIINT",		0x04, 0x04 },
@@ -1119,7 +1044,7 @@ ahc_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x91, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRINT_parse_table[] = {
+static const ahc_reg_parse_entry_t CLRINT_parse_table[] = {
 	{ "CLRSEQINT",		0x01, 0x01 },
 	{ "CLRCMDINT",		0x02, 0x02 },
 	{ "CLRSCSIINT",		0x04, 0x04 },
@@ -1134,7 +1059,7 @@ ahc_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t ERROR_parse_table[] = {
+static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "ILLHADDR",		0x01, 0x01 },
 	{ "ILLSADDR",		0x02, 0x02 },
 	{ "ILLOPCODE",		0x04, 0x04 },
@@ -1152,7 +1077,7 @@ ahc_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -1172,7 +1097,7 @@ ahc_dfcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x93, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
@@ -1198,20 +1123,13 @@ ahc_dfwaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_dfraddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFRADDR",
-	    0x97, regvalue, cur_col, wrap));
-}
-
-int
 ahc_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "DFDAT",
 	    0x99, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
+static const ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
 	{ "SCBAUTO",		0x80, 0x80 },
 	{ "SCBCNT_MASK",	0x1f, 0x1f }
 };
@@ -1231,20 +1149,13 @@ ahc_qinfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 }
 
 int
-ahc_qincnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QINCNT",
-	    0x9c, regvalue, cur_col, wrap));
-}
-
-int
 ahc_qoutfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "QOUTFIFO",
 	    0x9d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
+static const ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
 	{ "TARGCRCCNTEN",	0x04, 0x04 },
 	{ "TARGCRCENDEN",	0x08, 0x08 },
 	{ "CRCREQCHKEN",	0x10, 0x10 },
@@ -1260,14 +1171,7 @@ ahc_crccontrol1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x9d, regvalue, cur_col, wrap));
 }
 
-int
-ahc_qoutcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QOUTCNT",
-	    0x9e, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_OUT_PHASE",	0x01, 0x01 },
 	{ "DATA_IN_PHASE",	0x02, 0x02 },
 	{ "MSG_OUT_PHASE",	0x04, 0x04 },
@@ -1284,7 +1188,7 @@ ahc_scsiphase_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
+static const ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
 	{ "ALT_MODE",		0x80, 0x80 }
 };
 
@@ -1351,7 +1255,7 @@ ahc_scb_dataptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xac, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_LAST_SEG",	0x80, 0x80 },
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f }
 };
@@ -1363,7 +1267,7 @@ ahc_scb_datacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xb0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_RESID_VALID",	0x04, 0x04 }
@@ -1376,7 +1280,7 @@ ahc_scb_sgptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xb4, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "ULTRAENB",		0x08, 0x08 },
 	{ "MK_MESSAGE",		0x10, 0x10 },
@@ -1394,7 +1298,7 @@ ahc_scb_control_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xb8, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "TWIN_CHNLB",		0x80, 0x80 },
 	{ "OID",		0x0f, 0x0f },
 	{ "TWIN_TID",		0x70, 0x70 },
@@ -1408,7 +1312,7 @@ ahc_scb_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xb9, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x80, 0x80 },
 	{ "LID",		0x3f, 0x3f }
 };
@@ -1455,14 +1359,7 @@ ahc_scb_next_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xbf, regvalue, cur_col, wrap));
 }
 
-int
-ahc_scb_64_spare_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCB_64_SPARE",
-	    0xc0, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
+static const ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
 	{ "DO_2840",		0x01, 0x01 },
 	{ "CK_2840",		0x02, 0x02 },
 	{ "CS_2840",		0x04, 0x04 }
@@ -1475,7 +1372,7 @@ ahc_seectl_2840_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
+static const ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
 	{ "DI_2840",		0x01, 0x01 },
 	{ "EEPROM_TF",		0x80, 0x80 },
 	{ "ADSEL",		0x1e, 0x1e },
@@ -1524,7 +1421,7 @@ ahc_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xea, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGRESET",		0x01, 0x01 },
 	{ "SG_FETCH_NEEDED",	0x02, 0x02 },
 	{ "CCSGEN",		0x08, 0x08 },
@@ -1552,7 +1449,7 @@ ahc_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xed, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
 	{ "CCSCBRESET",		0x01, 0x01 },
 	{ "CCSCBDIR",		0x04, 0x04 },
 	{ "CCSCBEN",		0x08, 0x08 },
@@ -1610,7 +1507,7 @@ ahc_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xf8, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
+static const ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
 	{ "SDSCB_ROLLOVER",	0x10, 0x10 },
 	{ "SNSCB_ROLLOVER",	0x20, 0x20 },
 	{ "SCB_AVAIL",		0x40, 0x40 },
@@ -1625,7 +1522,7 @@ ahc_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xfa, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
+static const ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
 	{ "RD_DFTHRSH_MIN",	0x00, 0x00 },
 	{ "WR_DFTHRSH_MIN",	0x00, 0x00 },
 	{ "RD_DFTHRSH_25",	0x01, 0x01 },
@@ -1653,7 +1550,7 @@ ahc_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xfb, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+static const ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -1666,7 +1563,7 @@ ahc_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
 	    0xfc, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
+static const ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
diff --git a/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped b/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
index 4cee085..07e93fb 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
+++ b/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped
@@ -5,7 +5,7 @@
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xb2, 0x00, 0x00, 0x08,
 	0xf7, 0x11, 0x22, 0x08,
 	0x00, 0x65, 0xee, 0x59,
@@ -1081,7 +1081,7 @@ ahc_patch0_func(struct ahc_softc *ahc)
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahc_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
@@ -1291,7 +1291,7 @@ static struct patch {
 	{ ahc_patch4_func, 865, 12, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {

--------------080808010001050708020702--
