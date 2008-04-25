From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: [PATCH 5/5] aic7xxx: update shipped files
Date: Fri, 25 Apr 2008 04:44:26 +0200
Message-ID: <200804250444.26373.vda.linux@googlemail.com>
References: <200804250432.16943.vda.linux@googlemail.com> <200804250436.01295.vda.linux@googlemail.com> <200804250441.43480.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_KWUEIyeWbNVlcHz"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:35301 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbYDYCps (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 22:45:48 -0400
Received: by fg-out-1718.google.com with SMTP id l27so3383980fgb.17
        for <linux-scsi@vger.kernel.org>; Thu, 24 Apr 2008 19:45:45 -0700 (PDT)
In-Reply-To: <200804250441.43480.vda.linux@googlemail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

--Boundary-00=_KWUEIyeWbNVlcHz
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

After previous patch shipped files are out of sync.

This patch updates them.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_KWUEIyeWbNVlcHz
Content-Type: text/x-diff;
  charset="koi8-r";
  name="aic_debloat_5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="aic_debloat_5.diff"

--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic79xx_reg.h_shipped	Fri Apr 25 02:34:36 2008
@@ -12,71 +12,15 @@
 	uint8_t	 mask;
 } ahd_reg_parse_entry_t;
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_mode_ptr_print;
-#else
-#define ahd_mode_ptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MODE_PTR", 0x00, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_intstat_print;
 #else
 #define ahd_intstat_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "INTSTAT", 0x01, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqintcode_print;
-#else
-#define ahd_seqintcode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQINTCODE", 0x02, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrint_print;
-#else
-#define ahd_clrint_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRINT", 0x03, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_error_print;
-#else
-#define ahd_error_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ERROR", 0x04, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrerr_print;
-#else
-#define ahd_clrerr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRERR", 0x04, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hcntrl_print;
-#else
-#define ahd_hcntrl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HCNTRL", 0x05, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hnscb_qoff_print;
-#else
-#define ahd_hnscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HNSCB_QOFF", 0x06, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hescb_qoff_print;
-#else
-#define ahd_hescb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HESCB_QOFF", 0x08, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_hs_mailbox_print;
 #else
 #define ahd_hs_mailbox_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "HS_MAILBOX", 0x0b, regvalue, cur_col, wrap)
@@ -89,50 +33,8 @@
     ahd_print_register(NULL, 0, "SEQINTSTAT", 0x0c, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrseqintstat_print;
-#else
-#define ahd_clrseqintstat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSEQINTSTAT", 0x0c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_swtimer_print;
-#else
-#define ahd_swtimer_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SWTIMER", 0x0e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_snscb_qoff_print;
-#else
-#define ahd_snscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SNSCB_QOFF", 0x10, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sescb_qoff_print;
-#else
-#define ahd_sescb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SESCB_QOFF", 0x12, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sdscb_qoff_print;
-#else
-#define ahd_sdscb_qoff_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SDSCB_QOFF", 0x14, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_qoff_ctlsta_print;
-#else
-#define ahd_qoff_ctlsta_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "QOFF_CTLSTA", 0x16, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_intctl_print;
 #else
 #define ahd_intctl_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "INTCTL", 0x18, regvalue, cur_col, wrap)
@@ -145,15 +47,8 @@
     ahd_print_register(NULL, 0, "DFCNTRL", 0x19, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dscommand0_print;
-#else
-#define ahd_dscommand0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSCOMMAND0", 0x19, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dfstatus_print;
 #else
 #define ahd_dfstatus_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "DFSTATUS", 0x1a, regvalue, cur_col, wrap)
@@ -166,232 +61,8 @@
     ahd_print_register(NULL, 0, "SG_CACHE_SHADOW", 0x1b, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_arbctl_print;
-#else
-#define ahd_arbctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ARBCTL", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sg_cache_pre_print;
-#else
-#define ahd_sg_cache_pre_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SG_CACHE_PRE", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqin_print;
-#else
-#define ahd_lqin_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQIN", 0x20, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_lunptr_print;
-#else
-#define ahd_lunptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LUNPTR", 0x22, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_cmdlenptr_print;
-#else
-#define ahd_cmdlenptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMDLENPTR", 0x25, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_attrptr_print;
-#else
-#define ahd_attrptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ATTRPTR", 0x26, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flagptr_print;
-#else
-#define ahd_flagptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLAGPTR", 0x27, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cmdptr_print;
-#else
-#define ahd_cmdptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CMDPTR", 0x28, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_qnextptr_print;
-#else
-#define ahd_qnextptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "QNEXTPTR", 0x29, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_idptr_print;
-#else
-#define ahd_idptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "IDPTR", 0x2a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_abrtbyteptr_print;
-#else
-#define ahd_abrtbyteptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ABRTBYTEPTR", 0x2b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_abrtbitptr_print;
-#else
-#define ahd_abrtbitptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ABRTBITPTR", 0x2c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_lunlen_print;
-#else
-#define ahd_lunlen_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LUNLEN", 0x30, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_cdblimit_print;
-#else
-#define ahd_cdblimit_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CDBLIMIT", 0x31, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_maxcmd_print;
-#else
-#define ahd_maxcmd_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MAXCMD", 0x32, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_maxcmdcnt_print;
-#else
-#define ahd_maxcmdcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MAXCMDCNT", 0x33, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_lqctl1_print;
-#else
-#define ahd_lqctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQCTL1", 0x38, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsbist0_print;
-#else
-#define ahd_scsbist0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSBIST0", 0x39, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqctl2_print;
-#else
-#define ahd_lqctl2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQCTL2", 0x39, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "SCSISEQ0", 0x3a, regvalue, cur_col, wrap)
@@ -404,71 +75,15 @@
     ahd_print_register(NULL, 0, "SCSISEQ1", 0x3b, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sxfrctl0_print;
-#else
-#define ahd_sxfrctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SXFRCTL0", 0x3c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_sxfrctl1_print;
-#else
-#define ahd_sxfrctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SXFRCTL1", 0x3d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "DFFSTAT", 0x3f, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsisigo_print;
-#else
-#define ahd_scsisigo_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSISIGO", 0x40, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_multargid_print;
-#else
-#define ahd_multargid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MULTARGID", 0x40, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsisigi_print;
 #else
 #define ahd_scsisigi_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SCSISIGI", 0x41, regvalue, cur_col, wrap)
@@ -481,64 +96,22 @@
     ahd_print_register(NULL, 0, "SCSIPHASE", 0x42, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsidat0_img_print;
-#else
-#define ahd_scsidat0_img_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIDAT0_IMG", 0x43, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scsidat_print;
-#else
-#define ahd_scsidat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSIDAT", 0x44, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_scsibus_print;
 #else
 #define ahd_scsibus_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SCSIBUS", 0x46, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_targidin_print;
-#else
-#define ahd_targidin_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TARGIDIN", 0x48, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_selid_print;
 #else
 #define ahd_selid_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SELID", 0x49, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_optionmode_print;
-#else
-#define ahd_optionmode_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OPTIONMODE", 0x4a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sblkctl_print;
-#else
-#define ahd_sblkctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SBLKCTL", 0x4a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "SSTAT0", 0x4b, regvalue, cur_col, wrap)
@@ -551,15 +124,8 @@
     ahd_print_register(NULL, 0, "SIMODE0", 0x4b, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint1_print;
-#else
-#define ahd_clrsint1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT1", 0x4c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sstat1_print;
 #else
 #define ahd_sstat1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SSTAT1", 0x4c, regvalue, cur_col, wrap)
@@ -572,92 +138,36 @@
     ahd_print_register(NULL, 0, "SSTAT2", 0x4d, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode2_print;
-#else
-#define ahd_simode2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE2", 0x4d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint2_print;
-#else
-#define ahd_clrsint2_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT2", 0x4d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_perrdiag_print;
 #else
 #define ahd_perrdiag_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "PERRDIAG", 0x4e, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqistate_print;
-#else
-#define ahd_lqistate_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQISTATE", 0x4e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_soffcnt_print;
 #else
 #define ahd_soffcnt_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SOFFCNT", 0x4f, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqostate_print;
-#else
-#define ahd_lqostate_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSTATE", 0x4f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqistat0_print;
 #else
 #define ahd_lqistat0_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQISTAT0", 0x50, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqiint0_print;
-#else
-#define ahd_clrlqiint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQIINT0", 0x50, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqimode0_print;
-#else
-#define ahd_lqimode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQIMODE0", 0x50, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqimode1_print;
-#else
-#define ahd_lqimode1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQIMODE1", 0x51, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqistat1_print;
 #else
 #define ahd_lqistat1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQISTAT1", 0x51, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqiint1_print;
-#else
-#define ahd_clrlqiint1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQIINT1", 0x51, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqistat2_print;
 #else
 #define ahd_lqistat2_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQISTAT2", 0x52, regvalue, cur_col, wrap)
@@ -670,134 +180,50 @@
     ahd_print_register(NULL, 0, "SSTAT3", 0x53, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_simode3_print;
-#else
-#define ahd_simode3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SIMODE3", 0x53, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrsint3_print;
-#else
-#define ahd_clrsint3_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSINT3", 0x53, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqostat0_print;
 #else
 #define ahd_lqostat0_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQOSTAT0", 0x54, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqoint0_print;
-#else
-#define ahd_clrlqoint0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQOINT0", 0x54, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqomode0_print;
-#else
-#define ahd_lqomode0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOMODE0", 0x54, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqomode1_print;
-#else
-#define ahd_lqomode1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOMODE1", 0x55, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqostat1_print;
 #else
 #define ahd_lqostat1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQOSTAT1", 0x55, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrlqoint1_print;
-#else
-#define ahd_clrlqoint1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRLQOINT1", 0x55, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_lqostat2_print;
 #else
 #define ahd_lqostat2_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LQOSTAT2", 0x56, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_os_space_cnt_print;
-#else
-#define ahd_os_space_cnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "OS_SPACE_CNT", 0x56, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_simode1_print;
 #else
 #define ahd_simode1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SIMODE1", 0x57, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_gsfifo_print;
-#else
-#define ahd_gsfifo_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "GSFIFO", 0x58, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_dffsxfrctl_print;
 #else
 #define ahd_dffsxfrctl_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "DFFSXFRCTL", 0x5a, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lqoscsctl_print;
-#else
-#define ahd_lqoscsctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LQOSCSCTL", 0x5a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_nextscb_print;
-#else
-#define ahd_nextscb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEXTSCB", 0x5a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_clrseqintsrc_print;
-#else
-#define ahd_clrseqintsrc_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CLRSEQINTSRC", 0x5b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqintsrc_print;
 #else
 #define ahd_seqintsrc_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SEQINTSRC", 0x5b, regvalue, cur_col, wrap)
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
     ahd_print_register(NULL, 0, "SEQIMODE", 0x5c, regvalue, cur_col, wrap)
@@ -810,638 +236,29 @@
     ahd_print_register(NULL, 0, "MDFFSTAT", 0x5d, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_crccontrol_print;
-#else
-#define ahd_crccontrol_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CRCCONTROL", 0x5d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dfftag_print;
-#else
-#define ahd_dfftag_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFFTAG", 0x5e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lastscb_print;
-#else
-#define ahd_lastscb_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LASTSCB", 0x5e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_shaddr_print;
-#else
-#define ahd_shaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SHADDR", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_negoaddr_print;
-#else
-#define ahd_negoaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEGOADDR", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dgrpcrci_print;
-#else
-#define ahd_dgrpcrci_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DGRPCRCI", 0x60, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_negperiod_print;
-#else
-#define ahd_negperiod_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEGPERIOD", 0x61, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_packcrci_print;
-#else
-#define ahd_packcrci_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PACKCRCI", 0x62, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_negoffset_print;
-#else
-#define ahd_negoffset_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEGOFFSET", 0x62, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_negppropts_print;
-#else
-#define ahd_negppropts_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEGPPROPTS", 0x63, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_negconopts_print;
-#else
-#define ahd_negconopts_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NEGCONOPTS", 0x64, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_annexcol_print;
-#else
-#define ahd_annexcol_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ANNEXCOL", 0x65, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_annexdat_print;
-#else
-#define ahd_annexdat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ANNEXDAT", 0x66, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scschkn_print;
-#else
-#define ahd_scschkn_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCSCHKN", 0x66, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_iownid_print;
-#else
-#define ahd_iownid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "IOWNID", 0x67, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_pll960ctl0_print;
-#else
-#define ahd_pll960ctl0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PLL960CTL0", 0x68, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_shcnt_print;
-#else
-#define ahd_shcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SHCNT", 0x68, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_townid_print;
-#else
-#define ahd_townid_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TOWNID", 0x69, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "SELOID", 0x6b, regvalue, cur_col, wrap)
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
-ahd_reg_print_t ahd_haddr_print;
-#else
-#define ahd_haddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HADDR", 0x70, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_hcnt_print;
-#else
-#define ahd_hcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HCNT", 0x78, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_hodmaen_print;
-#else
-#define ahd_hodmaen_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "HODMAEN", 0x7a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbhaddr_print;
-#else
-#define ahd_scbhaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBHADDR", 0x7c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghaddr_print;
-#else
-#define ahd_sghaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHADDR", 0x7c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbhcnt_print;
-#else
-#define ahd_scbhcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBHCNT", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sghcnt_print;
-#else
-#define ahd_sghcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGHCNT", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dff_thrsh_print;
-#else
-#define ahd_dff_thrsh_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFF_THRSH", 0x88, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_pcixctl_print;
-#else
-#define ahd_pcixctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PCIXCTL", 0x93, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_dchspltstat0_print;
-#else
-#define ahd_dchspltstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHSPLTSTAT0", 0x96, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_dchspltstat1_print;
-#else
-#define ahd_dchspltstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DCHSPLTSTAT1", 0x97, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_sgspltstat0_print;
-#else
-#define ahd_sgspltstat0_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGSPLTSTAT0", 0x9e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sgspltstat1_print;
-#else
-#define ahd_sgspltstat1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SGSPLTSTAT1", 0x9f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sfunct_print;
-#else
-#define ahd_sfunct_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SFUNCT", 0x9f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_df0pcistat_print;
-#else
-#define ahd_df0pcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DF0PCISTAT", 0xa0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_reg0_print;
 #else
 #define ahd_reg0_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "REG0", 0xa0, regvalue, cur_col, wrap)
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
 ahd_reg_print_t ahd_reg1_print;
 #else
 #define ahd_reg1_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "REG1", 0xa2, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "REG_ISR", 0xa4, regvalue, cur_col, wrap)
@@ -1454,78 +271,15 @@
     ahd_print_register(NULL, 0, "SG_STATE", 0xa6, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_msipcistat_print;
-#else
-#define ahd_msipcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "MSIPCISTAT", 0xa6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_targpcistat_print;
-#else
-#define ahd_targpcistat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "TARGPCISTAT", 0xa7, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_data_count_odd_print;
 #else
 #define ahd_data_count_odd_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "DATA_COUNT_ODD", 0xa7, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbptr_print;
-#else
-#define ahd_scbptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBPTR", 0xa8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbacnt_print;
-#else
-#define ahd_ccscbacnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBACNT", 0xab, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_scbautoptr_print;
-#else
-#define ahd_scbautoptr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SCBAUTOPTR", 0xab, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgaddr_print;
-#else
-#define ahd_ccsgaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGADDR", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbadr_bk_print;
-#else
-#define ahd_ccscbadr_bk_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBADR_BK", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbaddr_print;
-#else
-#define ahd_ccscbaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBADDR", 0xac, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "CCSCBCTL", 0xad, regvalue, cur_col, wrap)
@@ -1538,386 +292,22 @@
     ahd_print_register(NULL, 0, "CCSGCTL", 0xad, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccsgram_print;
-#else
-#define ahd_ccsgram_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSGRAM", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flexadr_print;
-#else
-#define ahd_flexadr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLEXADR", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ccscbram_print;
-#else
-#define ahd_ccscbram_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CCSCBRAM", 0xb0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_brddat_print;
-#else
-#define ahd_brddat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BRDDAT", 0xb8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_brdctl_print;
-#else
-#define ahd_brdctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "BRDCTL", 0xb9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seeadr_print;
-#else
-#define ahd_seeadr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEEADR", 0xba, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seedat_print;
-#else
-#define ahd_seedat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEEDAT", 0xbc, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seectl_print;
-#else
-#define ahd_seectl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEECTL", 0xbe, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seestat_print;
-#else
-#define ahd_seestat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEESTAT", 0xbe, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_dspdatactl_print;
-#else
-#define ahd_dspdatactl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSPDATACTL", 0xc1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_dfdat_print;
-#else
-#define ahd_dfdat_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DFDAT", 0xc4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dspselect_print;
-#else
-#define ahd_dspselect_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DSPSELECT", 0xc4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_wrtbiasctl_print;
-#else
-#define ahd_wrtbiasctl_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "WRTBIASCTL", 0xc5, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
     ahd_print_register(NULL, 0, "SEQCTL0", 0xd6, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqctl1_print;
-#else
-#define ahd_seqctl1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQCTL1", 0xd7, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_flags_print;
-#else
-#define ahd_flags_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FLAGS", 0xd8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_seqintctl_print;
 #else
 #define ahd_seqintctl_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "SEQINTCTL", 0xd9, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_seqram_print;
-#else
-#define ahd_seqram_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SEQRAM", 0xda, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_prgmcnt_print;
-#else
-#define ahd_prgmcnt_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "PRGMCNT", 0xde, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_accum_print;
-#else
-#define ahd_accum_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ACCUM", 0xe0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sindex_print;
-#else
-#define ahd_sindex_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SINDEX", 0xe2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dindex_print;
-#else
-#define ahd_dindex_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DINDEX", 0xe4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
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
-ahd_reg_print_t ahd_allones_print;
-#else
-#define ahd_allones_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ALLONES", 0xe8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_allzeros_print;
-#else
-#define ahd_allzeros_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "ALLZEROS", 0xea, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_none_print;
-#else
-#define ahd_none_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "NONE", 0xea, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_sindir_print;
-#else
-#define ahd_sindir_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "SINDIR", 0xec, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_dindir_print;
-#else
-#define ahd_dindir_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "DINDIR", 0xed, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_function1_print;
-#else
-#define ahd_function1_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "FUNCTION1", 0xf0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_stack_print;
-#else
-#define ahd_stack_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "STACK", 0xf2, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intvec1_addr_print;
-#else
-#define ahd_intvec1_addr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTVEC1_ADDR", 0xf4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_curaddr_print;
-#else
-#define ahd_curaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "CURADDR", 0xf4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_lastaddr_print;
-#else
-#define ahd_lastaddr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "LASTADDR", 0xf6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_intvec2_addr_print;
-#else
-#define ahd_intvec2_addr_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "INTVEC2_ADDR", 0xf6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_longjmp_addr_print;
 #else
 #define ahd_longjmp_addr_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "LONGJMP_ADDR", 0xf8, regvalue, cur_col, wrap)
@@ -1934,15 +324,8 @@
 ahd_reg_print_t ahd_waiting_scb_tails_print;
 #else
 #define ahd_waiting_scb_tails_print(regvalue, cur_col, wrap) \
     ahd_print_register(NULL, 0, "WAITING_SCB_TAILS", 0x100, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahd_reg_print_t ahd_ahd_pci_config_base_print;
-#else
-#define ahd_ahd_pci_config_base_print(regvalue, cur_col, wrap) \
-    ahd_print_register(NULL, 0, "AHD_PCI_CONFIG_BASE", 0x100, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
 ahd_reg_print_t ahd_sram_base_print;
--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic79xx_reg_print.c_shipped	Fri Apr 25 02:34:36 2008
@@ -7,21 +7,9 @@
  */
 
 #include "aic79xx_osm.h"
 
-static ahd_reg_parse_entry_t MODE_PTR_parse_table[] = {
-	{ "SRC_MODE",		0x07, 0x07 },
-	{ "DST_MODE",		0x70, 0x70 }
-};
-
-int
-ahd_mode_ptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(MODE_PTR_parse_table, 2, "MODE_PTR",
-	    0x00, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t INTSTAT_parse_table[] = {
 	{ "SPLTINT",		0x01, 0x01 },
 	{ "CMDCMPLT",		0x02, 0x02 },
 	{ "SEQINT",		0x04, 0x04 },
 	{ "SCSIINT",		0x08, 0x08 },
@@ -38,130 +26,9 @@
 	return (ahd_print_register(INTSTAT_parse_table, 9, "INTSTAT",
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTCODE_parse_table[] = {
-	{ "NO_SEQINT",		0x00, 0xff },
-	{ "BAD_PHASE",		0x01, 0xff },
-	{ "SEND_REJECT",	0x02, 0xff },
-	{ "PROTO_VIOLATION",	0x03, 0xff },
-	{ "NO_MATCH",		0x04, 0xff },
-	{ "IGN_WIDE_RES",	0x05, 0xff },
-	{ "PDATA_REINIT",	0x06, 0xff },
-	{ "HOST_MSG_LOOP",	0x07, 0xff },
-	{ "BAD_STATUS",		0x08, 0xff },
-	{ "DATA_OVERRUN",	0x09, 0xff },
-	{ "MKMSG_FAILED",	0x0a, 0xff },
-	{ "MISSED_BUSFREE",	0x0b, 0xff },
-	{ "DUMP_CARD_STATE",	0x0c, 0xff },
-	{ "ILLEGAL_PHASE",	0x0d, 0xff },
-	{ "INVALID_SEQINT",	0x0e, 0xff },
-	{ "CFG4ISTAT_INTR",	0x0f, 0xff },
-	{ "STATUS_OVERRUN",	0x10, 0xff },
-	{ "CFG4OVERRUN",	0x11, 0xff },
-	{ "ENTERING_NONPACK",	0x12, 0xff },
-	{ "TASKMGMT_FUNC_COMPLETE",0x13, 0xff },
-	{ "TASKMGMT_CMD_CMPLT_OKAY",0x14, 0xff },
-	{ "TRACEPOINT0",	0x15, 0xff },
-	{ "TRACEPOINT1",	0x16, 0xff },
-	{ "TRACEPOINT2",	0x17, 0xff },
-	{ "TRACEPOINT3",	0x18, 0xff },
-	{ "SAW_HWERR",		0x19, 0xff },
-	{ "BAD_SCB_STATUS",	0x1a, 0xff }
-};
-
-int
-ahd_seqintcode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEQINTCODE_parse_table, 27, "SEQINTCODE",
-	    0x02, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRINT_parse_table[] = {
-	{ "CLRSPLTINT",		0x01, 0x01 },
-	{ "CLRCMDINT",		0x02, 0x02 },
-	{ "CLRSEQINT",		0x04, 0x04 },
-	{ "CLRSCSIINT",		0x08, 0x08 },
-	{ "CLRPCIINT",		0x10, 0x10 },
-	{ "CLRSWTMINT",		0x20, 0x20 },
-	{ "CLRBRKADRINT",	0x40, 0x40 },
-	{ "CLRHWERRINT",	0x80, 0x80 }
-};
-
-int
-ahd_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRINT_parse_table, 8, "CLRINT",
-	    0x03, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t ERROR_parse_table[] = {
-	{ "DSCTMOUT",		0x02, 0x02 },
-	{ "ILLOPCODE",		0x04, 0x04 },
-	{ "SQPARERR",		0x08, 0x08 },
-	{ "DPARERR",		0x10, 0x10 },
-	{ "MPARERR",		0x20, 0x20 },
-	{ "CIOACCESFAIL",	0x40, 0x40 },
-	{ "CIOPARERR",		0x80, 0x80 }
-};
-
-int
-ahd_error_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(ERROR_parse_table, 7, "ERROR",
-	    0x04, regvalue, cur_col, wrap));
-}
-
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
-	{ "CHIPRST",		0x01, 0x01 },
-	{ "CHIPRSTACK",		0x01, 0x01 },
-	{ "INTEN",		0x02, 0x02 },
-	{ "PAUSE",		0x04, 0x04 },
-	{ "SWTIMER_START_B",	0x08, 0x08 },
-	{ "SWINT",		0x10, 0x10 },
-	{ "POWRDN",		0x40, 0x40 },
-	{ "SEQ_RESET",		0x80, 0x80 }
-};
-
-int
-ahd_hcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(HCNTRL_parse_table, 8, "HCNTRL",
-	    0x05, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hnscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HNSCB_QOFF",
-	    0x06, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hescb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HESCB_QOFF",
-	    0x08, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
+static const ahd_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
 	{ "ENINT_COALESCE",	0x40, 0x40 },
 	{ "HOST_TQINPOS",	0x80, 0x80 }
 };
 
@@ -171,9 +38,9 @@
 	return (ahd_print_register(HS_MAILBOX_parse_table, 2, "HS_MAILBOX",
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTSTAT_parse_table[] = {
 	{ "SEQ_SPLTINT",	0x01, 0x01 },
 	{ "SEQ_PCIINT",		0x02, 0x02 },
 	{ "SEQ_SCSIINT",	0x04, 0x04 },
 	{ "SEQ_SEQINT",		0x08, 0x08 },
@@ -186,80 +53,9 @@
 	return (ahd_print_register(SEQINTSTAT_parse_table, 5, "SEQINTSTAT",
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRSEQINTSTAT_parse_table[] = {
-	{ "CLRSEQ_SPLTINT",	0x01, 0x01 },
-	{ "CLRSEQ_PCIINT",	0x02, 0x02 },
-	{ "CLRSEQ_SCSIINT",	0x04, 0x04 },
-	{ "CLRSEQ_SEQINT",	0x08, 0x08 },
-	{ "CLRSEQ_SWTMRTO",	0x10, 0x10 }
-};
-
-int
-ahd_clrseqintstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSEQINTSTAT_parse_table, 5, "CLRSEQINTSTAT",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_swtimer_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SWTIMER",
-	    0x0e, regvalue, cur_col, wrap));
-}
-
-int
-ahd_snscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SNSCB_QOFF",
-	    0x10, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sescb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SESCB_QOFF",
-	    0x12, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SDSCB_QOFF",
-	    0x14, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
-	{ "SCB_QSIZE_4",	0x00, 0x0f },
-	{ "SCB_QSIZE_8",	0x01, 0x0f },
-	{ "SCB_QSIZE_16",	0x02, 0x0f },
-	{ "SCB_QSIZE_32",	0x03, 0x0f },
-	{ "SCB_QSIZE_64",	0x04, 0x0f },
-	{ "SCB_QSIZE_128",	0x05, 0x0f },
-	{ "SCB_QSIZE_256",	0x06, 0x0f },
-	{ "SCB_QSIZE_512",	0x07, 0x0f },
-	{ "SCB_QSIZE_1024",	0x08, 0x0f },
-	{ "SCB_QSIZE_2048",	0x09, 0x0f },
-	{ "SCB_QSIZE_4096",	0x0a, 0x0f },
-	{ "SCB_QSIZE_8192",	0x0b, 0x0f },
-	{ "SCB_QSIZE_16384",	0x0c, 0x0f },
-	{ "SCB_QSIZE",		0x0f, 0x0f },
-	{ "HS_MAILBOX_ACT",	0x10, 0x10 },
-	{ "SDSCB_ROLLOVR",	0x20, 0x20 },
-	{ "NEW_SCB_AVAIL",	0x40, 0x40 },
-	{ "EMPTY_SCB_AVAIL",	0x80, 0x80 }
-};
-
-int
-ahd_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(QOFF_CTLSTA_parse_table, 18, "QOFF_CTLSTA",
-	    0x16, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t INTCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t INTCTL_parse_table[] = {
 	{ "SPLTINTEN",		0x01, 0x01 },
 	{ "SEQINTEN",		0x02, 0x02 },
 	{ "SCSIINTEN",		0x04, 0x04 },
 	{ "PCIINTEN",		0x08, 0x08 },
@@ -275,9 +71,9 @@
 	return (ahd_print_register(INTCTL_parse_table, 8, "INTCTL",
 	    0x18, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const ahd_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "DIRECTIONEN",	0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "FIFOFLUSHACK",	0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
@@ -296,25 +92,9 @@
 	return (ahd_print_register(DFCNTRL_parse_table, 11, "DFCNTRL",
 	    0x19, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DSCOMMAND0_parse_table[] = {
-	{ "CIOPARCKEN",		0x01, 0x01 },
-	{ "DISABLE_TWATE",	0x02, 0x02 },
-	{ "EXTREQLCK",		0x10, 0x10 },
-	{ "MPARCKEN",		0x20, 0x20 },
-	{ "DPARCKEN",		0x40, 0x40 },
-	{ "CACHETHEN",		0x80, 0x80 }
-};
-
-int
-ahd_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSCOMMAND0_parse_table, 6, "DSCOMMAND0",
-	    0x19, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const ahd_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
 	{ "HDONE",		0x08, 0x08 },
@@ -329,9 +109,9 @@
 	return (ahd_print_register(DFSTATUS_parse_table, 7, "DFSTATUS",
 	    0x1a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
 	{ "LAST_SEG_DONE",	0x01, 0x01 },
 	{ "LAST_SEG",		0x02, 0x02 },
 	{ "ODD_SEG",		0x04, 0x04 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
@@ -343,289 +123,9 @@
 	return (ahd_print_register(SG_CACHE_SHADOW_parse_table, 4, "SG_CACHE_SHADOW",
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
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "ODD_SEG",		0x04, 0x04 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahd_sg_cache_pre_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SG_CACHE_PRE_parse_table, 3, "SG_CACHE_PRE",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lqin_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQIN",
-	    0x20, regvalue, cur_col, wrap));
-}
-
-int
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
-ahd_lunptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LUNPTR",
-	    0x22, regvalue, cur_col, wrap));
-}
-
-int
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
-ahd_cmdlenptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDLENPTR",
-	    0x25, regvalue, cur_col, wrap));
-}
-
-int
-ahd_attrptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ATTRPTR",
-	    0x26, regvalue, cur_col, wrap));
-}
-
-int
-ahd_flagptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLAGPTR",
-	    0x27, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cmdptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CMDPTR",
-	    0x28, regvalue, cur_col, wrap));
-}
-
-int
-ahd_qnextptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "QNEXTPTR",
-	    0x29, regvalue, cur_col, wrap));
-}
-
-int
-ahd_idptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "IDPTR",
-	    0x2a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_abrtbyteptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ABRTBYTEPTR",
-	    0x2b, regvalue, cur_col, wrap));
-}
-
-int
-ahd_abrtbitptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ABRTBITPTR",
-	    0x2c, regvalue, cur_col, wrap));
-}
-
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
-	{ "ILUNLEN",		0x0f, 0x0f },
-	{ "TLUNLEN",		0xf0, 0xf0 }
-};
-
-int
-ahd_lunlen_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LUNLEN_parse_table, 2, "LUNLEN",
-	    0x30, regvalue, cur_col, wrap));
-}
-
-int
-ahd_cdblimit_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CDBLIMIT",
-	    0x31, regvalue, cur_col, wrap));
-}
-
-int
-ahd_maxcmd_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMD",
-	    0x32, regvalue, cur_col, wrap));
-}
-
-int
-ahd_maxcmdcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MAXCMDCNT",
-	    0x33, regvalue, cur_col, wrap));
-}
-
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
-	{ "ABORTPENDING",	0x01, 0x01 },
-	{ "SINGLECMD",		0x02, 0x02 },
-	{ "PCI2PCI",		0x04, 0x04 }
-};
-
-int
-ahd_lqctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQCTL1_parse_table, 3, "LQCTL1",
-	    0x38, regvalue, cur_col, wrap));
-}
-
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
-	{ "LQOPAUSE",		0x01, 0x01 },
-	{ "LQOTOIDLE",		0x02, 0x02 },
-	{ "LQOCONTINUE",	0x04, 0x04 },
-	{ "LQORETRY",		0x08, 0x08 },
-	{ "LQIPAUSE",		0x10, 0x10 },
-	{ "LQITOIDLE",		0x20, 0x20 },
-	{ "LQICONTINUE",	0x40, 0x40 },
-	{ "LQIRETRY",		0x80, 0x80 }
-};
-
-int
-ahd_lqctl2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQCTL2_parse_table, 8, "LQCTL2",
-	    0x39, regvalue, cur_col, wrap));
-}
-
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
 	{ "ENSELO",		0x40, 0x40 },
@@ -638,9 +138,9 @@
 	return (ahd_print_register(SCSISEQ0_parse_table, 5, "SCSISEQ0",
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ1_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
 	{ "ENRSELI",		0x10, 0x10 },
@@ -654,74 +154,9 @@
 	return (ahd_print_register(SCSISEQ1_parse_table, 6, "SCSISEQ1",
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SXFRCTL0_parse_table[] = {
-	{ "SPIOEN",		0x08, 0x08 },
-	{ "BIOSCANCELEN",	0x10, 0x10 },
-	{ "DFPEXP",		0x40, 0x40 },
-	{ "DFON",		0x80, 0x80 }
-};
-
-int
-ahd_sxfrctl0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SXFRCTL0_parse_table, 4, "SXFRCTL0",
-	    0x3c, regvalue, cur_col, wrap));
-}
-
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
-	{ "STPWEN",		0x01, 0x01 },
-	{ "ACTNEGEN",		0x02, 0x02 },
-	{ "ENSTIMER",		0x04, 0x04 },
-	{ "STIMESEL",		0x18, 0x18 },
-	{ "ENSPCHK",		0x20, 0x20 },
-	{ "ENSACHK",		0x40, 0x40 },
-	{ "BITBUCKET",		0x80, 0x80 }
-};
-
-int
-ahd_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SXFRCTL1_parse_table, 7, "SXFRCTL1",
-	    0x3d, regvalue, cur_col, wrap));
-}
-
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
 	{ "FIFO0FREE",		0x10, 0x10 },
@@ -735,51 +170,17 @@
 	return (ahd_print_register(DFFSTAT_parse_table, 6, "DFFSTAT",
 	    0x3f, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISIGO_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
 	{ "P_DATAIN_DT",	0x60, 0xe0 },
 	{ "P_COMMAND",		0x80, 0xe0 },
 	{ "P_MESGOUT",		0xa0, 0xe0 },
 	{ "P_STATUS",		0xc0, 0xe0 },
 	{ "P_MESGIN",		0xe0, 0xe0 },
-	{ "ACKO",		0x01, 0x01 },
-	{ "REQO",		0x02, 0x02 },
-	{ "BSYO",		0x04, 0x04 },
-	{ "SELO",		0x08, 0x08 },
-	{ "ATNO",		0x10, 0x10 },
-	{ "MSGO",		0x20, 0x20 },
-	{ "IOO",		0x40, 0x40 },
-	{ "CDO",		0x80, 0x80 },
-	{ "PHASE_MASK",		0xe0, 0xe0 }
-};
-
-int
-ahd_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSISIGO_parse_table, 17, "SCSISIGO",
-	    0x40, regvalue, cur_col, wrap));
-}
-
-int
-ahd_multargid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "MULTARGID",
-	    0x40, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSISIGI_parse_table[] = {
-	{ "P_DATAOUT",		0x00, 0xe0 },
-	{ "P_DATAOUT_DT",	0x20, 0xe0 },
-	{ "P_DATAIN",		0x40, 0xe0 },
-	{ "P_DATAIN_DT",	0x60, 0xe0 },
-	{ "P_COMMAND",		0x80, 0xe0 },
-	{ "P_MESGOUT",		0xa0, 0xe0 },
-	{ "P_STATUS",		0xc0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 },
 	{ "ACKI",		0x01, 0x01 },
 	{ "REQI",		0x02, 0x02 },
 	{ "BSYI",		0x04, 0x04 },
 	{ "SELI",		0x08, 0x08 },
@@ -796,9 +197,9 @@
 	return (ahd_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
 	    0x41, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSIPHASE_parse_table[] = {
 	{ "DATA_OUT_PHASE",	0x01, 0x03 },
 	{ "DATA_IN_PHASE",	0x02, 0x03 },
 	{ "DATA_PHASE_MASK",	0x03, 0x03 },
 	{ "MSG_OUT_PHASE",	0x04, 0x04 },
@@ -814,41 +215,15 @@
 	    0x42, regvalue, cur_col, wrap));
 }
 
 int
-ahd_scsidat0_img_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCSIDAT0_IMG",
-	    0x43, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scsidat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCSIDAT",
-	    0x44, regvalue, cur_col, wrap));
-}
-
-int
 ahd_scsibus_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SCSIBUS",
 	    0x46, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t TARGIDIN_parse_table[] = {
-	{ "TARGID",		0x0f, 0x0f },
-	{ "CLKOUT",		0x80, 0x80 }
-};
-
-int
-ahd_targidin_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(TARGIDIN_parse_table, 2, "TARGIDIN",
-	    0x48, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SELID_parse_table[] = {
+static const ahd_reg_parse_entry_t SELID_parse_table[] = {
 	{ "ONEBIT",		0x08, 0x08 },
 	{ "SELID_MASK",		0xf0, 0xf0 }
 };
 
@@ -858,58 +233,9 @@
 	return (ahd_print_register(SELID_parse_table, 2, "SELID",
 	    0x49, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t OPTIONMODE_parse_table[] = {
-	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
-	{ "ENDGFORMCHK",	0x04, 0x04 },
-	{ "BUSFREEREV",		0x10, 0x10 },
-	{ "BIASCANCTL",		0x20, 0x20 },
-	{ "AUTOACKEN",		0x40, 0x40 },
-	{ "BIOSCANCTL",		0x80, 0x80 },
-	{ "OPTIONMODE_DEFAULTS",0x02, 0x02 }
-};
-
-int
-ahd_optionmode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(OPTIONMODE_parse_table, 7, "OPTIONMODE",
-	    0x4a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SBLKCTL_parse_table[] = {
-	{ "SELWIDE",		0x02, 0x02 },
-	{ "ENAB20",		0x04, 0x04 },
-	{ "ENAB40",		0x08, 0x08 },
-	{ "DIAGLEDON",		0x40, 0x40 },
-	{ "DIAGLEDEN",		0x80, 0x80 }
-};
-
-int
-ahd_sblkctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SBLKCTL_parse_table, 5, "SBLKCTL",
-	    0x4a, regvalue, cur_col, wrap));
-}
-
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
 	{ "IOERR",		0x08, 0x08 },
@@ -925,9 +251,9 @@
 	return (ahd_print_register(SSTAT0_parse_table, 8, "SSTAT0",
 	    0x4b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENARBDO",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENOVERRUN",		0x04, 0x04 },
 	{ "ENIOERR",		0x08, 0x08 },
@@ -942,26 +268,9 @@
 	return (ahd_print_register(SIMODE0_parse_table, 7, "SIMODE0",
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
-};
-
-int
-ahd_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x4c, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "STRB2FAST",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
 	{ "BUSFREE",		0x08, 0x08 },
@@ -977,9 +286,9 @@
 	return (ahd_print_register(SSTAT1_parse_table, 8, "SSTAT1",
 	    0x4c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "BUSFREE_LQO",	0x40, 0xc0 },
 	{ "BUSFREE_DFF0",	0x80, 0xc0 },
 	{ "BUSFREE_DFF1",	0xc0, 0xc0 },
 	{ "DMADONE",		0x01, 0x01 },
@@ -997,36 +306,9 @@
 	return (ahd_print_register(SSTAT2_parse_table, 10, "SSTAT2",
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
-	{ "CLRDMADONE",		0x01, 0x01 },
-	{ "CLRSDONE",		0x02, 0x02 },
-	{ "CLRWIDE_RES",	0x04, 0x04 },
-	{ "CLRNONPACKREQ",	0x20, 0x20 }
-};
-
-int
-ahd_clrsint2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT2_parse_table, 4, "CLRSINT2",
-	    0x4d, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
+static const ahd_reg_parse_entry_t PERRDIAG_parse_table[] = {
 	{ "DTERR",		0x01, 0x01 },
 	{ "DGFORMERR",		0x02, 0x02 },
 	{ "CRCERR",		0x04, 0x04 },
 	{ "AIPERR",		0x08, 0x08 },
@@ -1043,29 +325,15 @@
 	    0x4e, regvalue, cur_col, wrap));
 }
 
 int
-ahd_lqistate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQISTATE",
-	    0x4e, regvalue, cur_col, wrap));
-}
-
-int
 ahd_soffcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SOFFCNT",
 	    0x4f, regvalue, cur_col, wrap));
 }
 
-int
-ahd_lqostate_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LQOSTATE",
-	    0x4f, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT0_parse_table[] = {
 	{ "LQIATNCMD",		0x01, 0x01 },
 	{ "LQIATNLQ",		0x02, 0x02 },
 	{ "LQIBADLQT",		0x04, 0x04 },
 	{ "LQICRCT2",		0x08, 0x08 },
@@ -1079,59 +347,9 @@
 	return (ahd_print_register(LQISTAT0_parse_table, 6, "LQISTAT0",
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
-	{ "ENLQIATNCMD",	0x01, 0x01 },
-	{ "ENLQIATNLQ",		0x02, 0x02 },
-	{ "ENLQIBADLQT",	0x04, 0x04 },
-	{ "ENLQICRCT2",		0x08, 0x08 },
-	{ "ENLQICRCT1",		0x10, 0x10 },
-	{ "ENLQIATNQASK",	0x20, 0x20 }
-};
-
-int
-ahd_lqimode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQIMODE0_parse_table, 6, "LQIMODE0",
-	    0x50, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQIMODE1_parse_table[] = {
-	{ "ENLQIOVERI_NLQ",	0x01, 0x01 },
-	{ "ENLQIOVERI_LQ",	0x02, 0x02 },
-	{ "ENLQIBADLQI",	0x04, 0x04 },
-	{ "ENLQICRCI_NLQ",	0x08, 0x08 },
-	{ "ENLQICRCI_LQ",	0x10, 0x10 },
-	{ "ENLIQABORT",		0x20, 0x20 },
-	{ "ENLQIPHASE_NLQ",	0x40, 0x40 },
-	{ "ENLQIPHASE_LQ",	0x80, 0x80 }
-};
-
-int
-ahd_lqimode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQIMODE1_parse_table, 8, "LQIMODE1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT1_parse_table[] = {
 	{ "LQIOVERI_NLQ",	0x01, 0x01 },
 	{ "LQIOVERI_LQ",	0x02, 0x02 },
 	{ "LQIBADLQI",		0x04, 0x04 },
 	{ "LQICRCI_NLQ",	0x08, 0x08 },
@@ -1147,27 +365,9 @@
 	return (ahd_print_register(LQISTAT1_parse_table, 8, "LQISTAT1",
 	    0x51, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQIINT1_parse_table[] = {
-	{ "CLRLQIOVERI_NLQ",	0x01, 0x01 },
-	{ "CLRLQIOVERI_LQ",	0x02, 0x02 },
-	{ "CLRLQIBADLQI",	0x04, 0x04 },
-	{ "CLRLQICRCI_NLQ",	0x08, 0x08 },
-	{ "CLRLQICRCI_LQ",	0x10, 0x10 },
-	{ "CLRLIQABORT",	0x20, 0x20 },
-	{ "CLRLQIPHASE_NLQ",	0x40, 0x40 },
-	{ "CLRLQIPHASE_LQ",	0x80, 0x80 }
-};
-
-int
-ahd_clrlqiint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQIINT1_parse_table, 8, "CLRLQIINT1",
-	    0x51, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQISTAT2_parse_table[] = {
 	{ "LQIGSAVAIL",		0x01, 0x01 },
 	{ "LQISTOPCMD",		0x02, 0x02 },
 	{ "LQISTOPLQ",		0x04, 0x04 },
 	{ "LQISTOPPKT",		0x08, 0x08 },
@@ -1183,9 +383,9 @@
 	return (ahd_print_register(LQISTAT2_parse_table, 8, "LQISTAT2",
 	    0x52, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const ahd_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OSRAMPERR",		0x01, 0x01 },
 	{ "NTRAMPERR",		0x02, 0x02 }
 };
 
@@ -1195,33 +395,9 @@
 	return (ahd_print_register(SSTAT3_parse_table, 2, "SSTAT3",
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SIMODE3_parse_table[] = {
-	{ "ENOSRAMPERR",	0x01, 0x01 },
-	{ "ENNTRAMPERR",	0x02, 0x02 }
-};
-
-int
-ahd_simode3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SIMODE3_parse_table, 2, "SIMODE3",
-	    0x53, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRSINT3_parse_table[] = {
-	{ "CLROSRAMPERR",	0x01, 0x01 },
-	{ "CLRNTRAMPERR",	0x02, 0x02 }
-};
-
-int
-ahd_clrsint3_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSINT3_parse_table, 2, "CLRSINT3",
-	    0x53, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT0_parse_table[] = {
 	{ "LQOTCRC",		0x01, 0x01 },
 	{ "LQOATNPKT",		0x02, 0x02 },
 	{ "LQOATNLQ",		0x04, 0x04 },
 	{ "LQOSTOPT2",		0x08, 0x08 },
@@ -1234,54 +410,9 @@
 	return (ahd_print_register(LQOSTAT0_parse_table, 5, "LQOSTAT0",
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQOINT0_parse_table[] = {
-	{ "CLRLQOTCRC",		0x01, 0x01 },
-	{ "CLRLQOATNPKT",	0x02, 0x02 },
-	{ "CLRLQOATNLQ",	0x04, 0x04 },
-	{ "CLRLQOSTOPT2",	0x08, 0x08 },
-	{ "CLRLQOTARGSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_clrlqoint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQOINT0_parse_table, 5, "CLRLQOINT0",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOMODE0_parse_table[] = {
-	{ "ENLQOTCRC",		0x01, 0x01 },
-	{ "ENLQOATNPKT",	0x02, 0x02 },
-	{ "ENLQOATNLQ",		0x04, 0x04 },
-	{ "ENLQOSTOPT2",	0x08, 0x08 },
-	{ "ENLQOTARGSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqomode0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOMODE0_parse_table, 5, "LQOMODE0",
-	    0x54, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOMODE1_parse_table[] = {
-	{ "ENLQOPHACHGINPKT",	0x01, 0x01 },
-	{ "ENLQOBUSFREE",	0x02, 0x02 },
-	{ "ENLQOBADQAS",	0x04, 0x04 },
-	{ "ENLQOSTOPI2",	0x08, 0x08 },
-	{ "ENLQOINITSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_lqomode1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOMODE1_parse_table, 5, "LQOMODE1",
-	    0x55, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT1_parse_table[] = {
 	{ "LQOPHACHGINPKT",	0x01, 0x01 },
 	{ "LQOBUSFREE",		0x02, 0x02 },
 	{ "LQOBADQAS",		0x04, 0x04 },
 	{ "LQOSTOPI2",		0x08, 0x08 },
@@ -1294,24 +425,9 @@
 	return (ahd_print_register(LQOSTAT1_parse_table, 5, "LQOSTAT1",
 	    0x55, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CLRLQOINT1_parse_table[] = {
-	{ "CLRLQOPHACHGINPKT",	0x01, 0x01 },
-	{ "CLRLQOBUSFREE",	0x02, 0x02 },
-	{ "CLRLQOBADQAS",	0x04, 0x04 },
-	{ "CLRLQOSTOPI2",	0x08, 0x08 },
-	{ "CLRLQOINITSCBPERR",	0x10, 0x10 }
-};
-
-int
-ahd_clrlqoint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRLQOINT1_parse_table, 5, "CLRLQOINT1",
-	    0x55, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
+static const ahd_reg_parse_entry_t LQOSTAT2_parse_table[] = {
 	{ "LQOSTOP0",		0x01, 0x01 },
 	{ "LQOPHACHGOUTPKT",	0x02, 0x02 },
 	{ "LQOWAITFIFO",	0x10, 0x10 },
 	{ "LQOPKT",		0xe0, 0xe0 }
@@ -1323,16 +439,9 @@
 	return (ahd_print_register(LQOSTAT2_parse_table, 4, "LQOSTAT2",
 	    0x56, regvalue, cur_col, wrap));
 }
 
-int
-ahd_os_space_cnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "OS_SPACE_CNT",
-	    0x56, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const ahd_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENSTRB2FAST",	0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
 	{ "ENBUSFREE",		0x08, 0x08 },
@@ -1348,16 +457,9 @@
 	return (ahd_print_register(SIMODE1_parse_table, 8, "SIMODE1",
 	    0x57, regvalue, cur_col, wrap));
 }
 
-int
-ahd_gsfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "GSFIFO",
-	    0x58, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t DFFSXFRCTL_parse_table[] = {
 	{ "RSTCHN",		0x01, 0x01 },
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "CLRSHCNT",		0x04, 0x04 },
 	{ "DFFBITBUCKET",	0x08, 0x08 }
@@ -1369,45 +471,9 @@
 	return (ahd_print_register(DFFSXFRCTL_parse_table, 4, "DFFSXFRCTL",
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LQOSCSCTL_parse_table[] = {
-	{ "LQONOCHKOVER",	0x01, 0x01 },
-	{ "LQOH2A_VERSION",	0x80, 0x80 }
-};
-
-int
-ahd_lqoscsctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(LQOSCSCTL_parse_table, 2, "LQOSCSCTL",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_nextscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEXTSCB",
-	    0x5a, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t CLRSEQINTSRC_parse_table[] = {
-	{ "CLRCFG4TCMD",	0x01, 0x01 },
-	{ "CLRCFG4ICMD",	0x02, 0x02 },
-	{ "CLRCFG4TSTAT",	0x04, 0x04 },
-	{ "CLRCFG4ISTAT",	0x08, 0x08 },
-	{ "CLRCFG4DATA",	0x10, 0x10 },
-	{ "CLRSAVEPTRS",	0x20, 0x20 },
-	{ "CLRCTXTDONE",	0x40, 0x40 }
-};
-
-int
-ahd_clrseqintsrc_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(CLRSEQINTSRC_parse_table, 7, "CLRSEQINTSRC",
-	    0x5b, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTSRC_parse_table[] = {
 	{ "CFG4TCMD",		0x01, 0x01 },
 	{ "CFG4ICMD",		0x02, 0x02 },
 	{ "CFG4TSTAT",		0x04, 0x04 },
 	{ "CFG4ISTAT",		0x08, 0x08 },
@@ -1422,16 +488,9 @@
 	return (ahd_print_register(SEQINTSRC_parse_table, 7, "SEQINTSRC",
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
 	{ "ENCFG4ISTAT",	0x08, 0x08 },
@@ -1446,9 +505,9 @@
 	return (ahd_print_register(SEQIMODE_parse_table, 7, "SEQIMODE",
 	    0x5c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
+static const ahd_reg_parse_entry_t MDFFSTAT_parse_table[] = {
 	{ "FIFOFREE",		0x01, 0x01 },
 	{ "DATAINFIFO",		0x02, 0x02 },
 	{ "DLZERO",		0x04, 0x04 },
 	{ "SHVALID",		0x08, 0x08 },
@@ -1463,997 +522,37 @@
 	return (ahd_print_register(MDFFSTAT_parse_table, 7, "MDFFSTAT",
 	    0x5d, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CRCCONTROL_parse_table[] = {
-	{ "CRCVALCHKEN",	0x40, 0x40 }
-};
-
 int
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
-int
-ahd_lastscb_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LASTSCB",
-	    0x5e, regvalue, cur_col, wrap));
-}
-
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
-int
-ahd_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SHADDR",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negoaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEGOADDR",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dgrpcrci_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DGRPCRCI",
-	    0x60, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negperiod_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEGPERIOD",
-	    0x61, regvalue, cur_col, wrap));
-}
-
-int
-ahd_packcrci_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PACKCRCI",
-	    0x62, regvalue, cur_col, wrap));
-}
-
-int
-ahd_negoffset_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NEGOFFSET",
-	    0x62, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t NEGPPROPTS_parse_table[] = {
-	{ "PPROPT_IUT",		0x01, 0x01 },
-	{ "PPROPT_DT",		0x02, 0x02 },
-	{ "PPROPT_QAS",		0x04, 0x04 },
-	{ "PPROPT_PACE",	0x08, 0x08 }
-};
-
-int
-ahd_negppropts_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NEGPPROPTS_parse_table, 4, "NEGPPROPTS",
-	    0x63, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t NEGCONOPTS_parse_table[] = {
-	{ "WIDEXFER",		0x01, 0x01 },
-	{ "ENAUTOATNO",		0x02, 0x02 },
-	{ "ENAUTOATNI",		0x04, 0x04 },
-	{ "ENSLOWCRC",		0x08, 0x08 },
-	{ "RTI_OVRDTRN",	0x10, 0x10 },
-	{ "RTI_WRTDIS",		0x20, 0x20 },
-	{ "ENSNAPSHOT",		0x40, 0x40 }
-};
-
-int
-ahd_negconopts_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NEGCONOPTS_parse_table, 7, "NEGCONOPTS",
-	    0x64, regvalue, cur_col, wrap));
-}
-
-int
-ahd_annexcol_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ANNEXCOL",
-	    0x65, regvalue, cur_col, wrap));
-}
-
-int
-ahd_annexdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ANNEXDAT",
-	    0x66, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCSCHKN_parse_table[] = {
-	{ "LSTSGCLRDIS",	0x01, 0x01 },
-	{ "SHVALIDSTDIS",	0x02, 0x02 },
-	{ "DFFACTCLR",		0x04, 0x04 },
-	{ "SDONEMSKDIS",	0x08, 0x08 },
-	{ "WIDERESEN",		0x10, 0x10 },
-	{ "CURRFIFODEF",	0x20, 0x20 },
-	{ "STSELSKIDDIS",	0x40, 0x40 }
-};
-
-int
-ahd_scschkn_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCSCHKN_parse_table, 7, "SCSCHKN",
-	    0x66, regvalue, cur_col, wrap));
-}
-
-int
-ahd_iownid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "IOWNID",
-	    0x67, regvalue, cur_col, wrap));
-}
-
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
-int
-ahd_shcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SHCNT",
-	    0x68, regvalue, cur_col, wrap));
-}
-
-int
-ahd_townid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "TOWNID",
-	    0x69, regvalue, cur_col, wrap));
-}
-
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
-int
 ahd_seloid_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SELOID",
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
 int
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
-int
-ahd_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HADDR",
-	    0x70, regvalue, cur_col, wrap));
-}
-
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
-int
-ahd_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HCNT",
-	    0x78, regvalue, cur_col, wrap));
-}
-
-int
-ahd_hodmaen_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "HODMAEN",
-	    0x7a, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scbhaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCBHADDR",
-	    0x7c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sghaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SGHADDR",
-	    0x7c, regvalue, cur_col, wrap));
-}
-
-int
-ahd_scbhcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCBHCNT",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sghcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SGHCNT",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DFF_THRSH_parse_table[] = {
-	{ "WR_DFTHRSH_MIN",	0x00, 0x70 },
-	{ "RD_DFTHRSH_MIN",	0x00, 0x07 },
-	{ "RD_DFTHRSH_25",	0x01, 0x07 },
-	{ "RD_DFTHRSH_50",	0x02, 0x07 },
-	{ "RD_DFTHRSH_63",	0x03, 0x07 },
-	{ "RD_DFTHRSH_75",	0x04, 0x07 },
-	{ "RD_DFTHRSH_85",	0x05, 0x07 },
-	{ "RD_DFTHRSH_90",	0x06, 0x07 },
-	{ "RD_DFTHRSH_MAX",	0x07, 0x07 },
-	{ "WR_DFTHRSH_25",	0x10, 0x70 },
-	{ "WR_DFTHRSH_50",	0x20, 0x70 },
-	{ "WR_DFTHRSH_63",	0x30, 0x70 },
-	{ "WR_DFTHRSH_75",	0x40, 0x70 },
-	{ "WR_DFTHRSH_85",	0x50, 0x70 },
-	{ "WR_DFTHRSH_90",	0x60, 0x70 },
-	{ "WR_DFTHRSH_MAX",	0x70, 0x70 },
-	{ "RD_DFTHRSH",		0x07, 0x07 },
-	{ "WR_DFTHRSH",		0x70, 0x70 }
-};
-
-int
-ahd_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DFF_THRSH_parse_table, 18, "DFF_THRSH",
-	    0x88, regvalue, cur_col, wrap));
-}
-
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
-	{ "CMPABCDIS",		0x01, 0x01 },
-	{ "TSCSERREN",		0x02, 0x02 },
-	{ "SRSPDPEEN",		0x04, 0x04 },
-	{ "SPLTSTADIS",		0x08, 0x08 },
-	{ "SPLTSMADIS",		0x10, 0x10 },
-	{ "UNEXPSCIEN",		0x20, 0x20 },
-	{ "SERRPULSE",		0x80, 0x80 }
-};
-
-int
-ahd_pcixctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(PCIXCTL_parse_table, 7, "PCIXCTL",
-	    0x93, regvalue, cur_col, wrap));
-}
-
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
-ahd_dchspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHSPLTSTAT0_parse_table, 8, "DCHSPLTSTAT0",
-	    0x96, regvalue, cur_col, wrap));
-}
-
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
-	{ "RXDATABUCKET",	0x01, 0x01 }
-};
-
-int
-ahd_dchspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DCHSPLTSTAT1_parse_table, 1, "DCHSPLTSTAT1",
-	    0x97, regvalue, cur_col, wrap));
-}
-
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
-ahd_sgspltstat0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGSPLTSTAT0_parse_table, 8, "SGSPLTSTAT0",
-	    0x9e, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SGSPLTSTAT1_parse_table[] = {
-	{ "RXDATABUCKET",	0x01, 0x01 }
-};
-
-int
-ahd_sgspltstat1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SGSPLTSTAT1_parse_table, 1, "SGSPLTSTAT1",
-	    0x9f, regvalue, cur_col, wrap));
-}
-
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
-ahd_df0pcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DF0PCISTAT_parse_table, 8, "DF0PCISTAT",
-	    0xa0, regvalue, cur_col, wrap));
-}
-
-int
 ahd_reg0_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "REG0",
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
 int
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
 ahd_reg1_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "REG1",
 	    0xa2, regvalue, cur_col, wrap));
 }
 
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
 int
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
-int
 ahd_reg_isr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "REG_ISR",
 	    0xa4, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
+static const ahd_reg_parse_entry_t SG_STATE_parse_table[] = {
 	{ "SEGS_AVAIL",		0x01, 0x01 },
 	{ "LOADING_NEEDED",	0x02, 0x02 },
 	{ "FETCH_INPROG",	0x04, 0x04 }
 };
@@ -2464,110 +563,16 @@
 	return (ahd_print_register(SG_STATE_parse_table, 3, "SG_STATE",
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
 int
-ahd_msipcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(MSIPCISTAT_parse_table, 6, "MSIPCISTAT",
-	    0xa6, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t TARGPCISTAT_parse_table[] = {
-	{ "TWATERR",		0x02, 0x02 },
-	{ "STA",		0x08, 0x08 },
-	{ "SSE",		0x40, 0x40 },
-	{ "DPE",		0x80, 0x80 }
-};
-
-int
-ahd_targpcistat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(TARGPCISTAT_parse_table, 4, "TARGPCISTAT",
-	    0xa7, regvalue, cur_col, wrap));
-}
-
-int
 ahd_data_count_odd_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "DATA_COUNT_ODD",
 	    0xa7, regvalue, cur_col, wrap));
 }
 
-int
-ahd_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SCBPTR",
-	    0xa8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbacnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBACNT",
-	    0xab, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SCBAUTOPTR_parse_table[] = {
-	{ "SCBPTR_OFF",		0x07, 0x07 },
-	{ "SCBPTR_ADDR",	0x38, 0x38 },
-	{ "AUSCBPTR_EN",	0x80, 0x80 }
-};
-
-int
-ahd_scbautoptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SCBAUTOPTR_parse_table, 3, "SCBAUTOPTR",
-	    0xab, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSGADDR",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbadr_bk_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBADR_BK",
-	    0xac, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBADDR",
-	    0xac, regvalue, cur_col, wrap));
-}
-
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
 	{ "CCARREN",		0x10, 0x10 },
@@ -2581,9 +586,9 @@
 	return (ahd_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
 	    0xad, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t CCSGCTL_parse_table[] = {
 	{ "CCSGRESET",		0x01, 0x01 },
 	{ "SG_FETCH_REQ",	0x02, 0x02 },
 	{ "CCSGENACK",		0x08, 0x08 },
 	{ "SG_CACHE_AVAIL",	0x10, 0x10 },
@@ -2597,316 +602,9 @@
 	return (ahd_print_register(CCSGCTL_parse_table, 6, "CCSGCTL",
 	    0xad, regvalue, cur_col, wrap));
 }
 
-int
-ahd_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSGRAM",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_flexadr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FLEXADR",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CCSCBRAM",
-	    0xb0, regvalue, cur_col, wrap));
-}
-
-int
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
-ahd_brddat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "BRDDAT",
-	    0xb8, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t BRDCTL_parse_table[] = {
-	{ "BRDSTB",		0x01, 0x01 },
-	{ "BRDRW",		0x02, 0x02 },
-	{ "BRDEN",		0x04, 0x04 },
-	{ "BRDADDR",		0x38, 0x38 },
-	{ "FLXARBREQ",		0x40, 0x40 },
-	{ "FLXARBACK",		0x80, 0x80 }
-};
-
-int
-ahd_brdctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(BRDCTL_parse_table, 6, "BRDCTL",
-	    0xb9, regvalue, cur_col, wrap));
-}
-
-int
-ahd_seeadr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEEADR",
-	    0xba, regvalue, cur_col, wrap));
-}
-
-int
-ahd_seedat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEEDAT",
-	    0xbc, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEECTL_parse_table[] = {
-	{ "SEEOP_ERAL",		0x40, 0x70 },
-	{ "SEEOP_WRITE",	0x50, 0x70 },
-	{ "SEEOP_READ",		0x60, 0x70 },
-	{ "SEEOP_ERASE",	0x70, 0x70 },
-	{ "SEESTART",		0x01, 0x01 },
-	{ "SEERST",		0x02, 0x02 },
-	{ "SEEOPCODE",		0x70, 0x70 },
-	{ "SEEOP_EWEN",		0x40, 0x40 },
-	{ "SEEOP_WALL",		0x40, 0x40 },
-	{ "SEEOP_EWDS",		0x40, 0x40 }
-};
-
-int
-ahd_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEECTL_parse_table, 10, "SEECTL",
-	    0xbe, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEESTAT_parse_table[] = {
-	{ "SEESTART",		0x01, 0x01 },
-	{ "SEEBUSY",		0x02, 0x02 },
-	{ "SEEARBACK",		0x04, 0x04 },
-	{ "LDALTID_L",		0x08, 0x08 },
-	{ "SEEOPCODE",		0x70, 0x70 },
-	{ "INIT_DONE",		0x80, 0x80 }
-};
-
-int
-ahd_seestat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(SEESTAT_parse_table, 6, "SEESTAT",
-	    0xbe, regvalue, cur_col, wrap));
-}
-
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
-	{ "XMITOFFSTDIS",	0x02, 0x02 },
-	{ "RCVROFFSTDIS",	0x04, 0x04 },
-	{ "DESQDIS",		0x10, 0x10 },
-	{ "BYPASSENAB",		0x80, 0x80 }
-};
-
-int
-ahd_dspdatactl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPDATACTL_parse_table, 4, "DSPDATACTL",
-	    0xc1, regvalue, cur_col, wrap));
-}
-
-int
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
-ahd_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DFDAT",
-	    0xc4, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t DSPSELECT_parse_table[] = {
-	{ "DSPSEL",		0x1f, 0x1f },
-	{ "AUTOINCEN",		0x80, 0x80 }
-};
-
-int
-ahd_dspselect_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(DSPSELECT_parse_table, 2, "DSPSELECT",
-	    0xc4, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t WRTBIASCTL_parse_table[] = {
-	{ "XMITMANVAL",		0x3f, 0x3f },
-	{ "AUTOXBCDIS",		0x80, 0x80 }
-};
-
-int
-ahd_wrtbiasctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(WRTBIASCTL_parse_table, 2, "WRTBIASCTL",
-	    0xc5, regvalue, cur_col, wrap));
-}
-
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
 	{ "BRKADRINTEN",	0x08, 0x08 },
@@ -2922,35 +620,9 @@
 	return (ahd_print_register(SEQCTL0_parse_table, 8, "SEQCTL0",
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
-	{ "CARRY",		0x01, 0x01 },
-	{ "ZERO",		0x02, 0x02 }
-};
-
-int
-ahd_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(FLAGS_parse_table, 2, "FLAGS",
-	    0xd8, regvalue, cur_col, wrap));
-}
-
-static ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQINTCTL_parse_table[] = {
 	{ "IRET",		0x01, 0x01 },
 	{ "INTMASK1",		0x02, 0x02 },
 	{ "INTMASK2",		0x04, 0x04 },
 	{ "SCS_SEQ_INT1M0",	0x08, 0x08 },
@@ -2966,138 +638,8 @@
 	    0xd9, regvalue, cur_col, wrap));
 }
 
 int
-ahd_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SEQRAM",
-	    0xda, regvalue, cur_col, wrap));
-}
-
-int
-ahd_prgmcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "PRGMCNT",
-	    0xde, regvalue, cur_col, wrap));
-}
-
-int
-ahd_accum_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ACCUM",
-	    0xe0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SINDEX",
-	    0xe2, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DINDEX",
-	    0xe4, regvalue, cur_col, wrap));
-}
-
-int
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
-ahd_allones_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ALLONES",
-	    0xe8, regvalue, cur_col, wrap));
-}
-
-int
-ahd_allzeros_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "ALLZEROS",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-int
-ahd_none_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "NONE",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-int
-ahd_sindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "SINDIR",
-	    0xec, regvalue, cur_col, wrap));
-}
-
-int
-ahd_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "DINDIR",
-	    0xed, regvalue, cur_col, wrap));
-}
-
-int
-ahd_function1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "FUNCTION1",
-	    0xf0, regvalue, cur_col, wrap));
-}
-
-int
-ahd_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "STACK",
-	    0xf2, regvalue, cur_col, wrap));
-}
-
-int
-ahd_intvec1_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INTVEC1_ADDR",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_curaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "CURADDR",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahd_lastaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "LASTADDR",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
-ahd_intvec2_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "INTVEC2_ADDR",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
 ahd_longjmp_addr_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "LONGJMP_ADDR",
 	    0xf8, regvalue, cur_col, wrap));
@@ -3117,15 +659,8 @@
 	    0x100, regvalue, cur_col, wrap));
 }
 
 int
-ahd_ahd_pci_config_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahd_print_register(NULL, 0, "AHD_PCI_CONFIG_BASE",
-	    0x100, regvalue, cur_col, wrap));
-}
-
-int
 ahd_sram_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahd_print_register(NULL, 0, "SRAM_BASE",
 	    0x100, regvalue, cur_col, wrap));
@@ -3214,9 +749,9 @@
 	return (ahd_print_register(NULL, 0, "MSG_OUT",
 	    0x137, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahd_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
 	{ "HDMAEN",		0x08, 0x08 },
@@ -3234,9 +769,9 @@
 	return (ahd_print_register(DMAPARAMS_parse_table, 10, "DMAPARAMS",
 	    0x138, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
 	{ "CMDPHASE_PENDING",	0x08, 0x08 },
@@ -3267,9 +802,9 @@
 	return (ahd_print_register(NULL, 0, "SAVED_LUN",
 	    0x13b, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const ahd_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "P_DATAOUT",		0x00, 0xe0 },
 	{ "P_DATAOUT_DT",	0x20, 0xe0 },
 	{ "P_DATAIN",		0x40, 0xe0 },
 	{ "P_DATAIN_DT",	0x60, 0xe0 },
@@ -3325,9 +860,9 @@
 	return (ahd_print_register(NULL, 0, "QOUTFIFO_NEXT_ADDR",
 	    0x144, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahd_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_MSG_LOOP_TARG",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP_READ",	0x03, 0x03 },
 	{ "CONT_MSG_LOOP_WRITE",0x04, 0x04 },
 	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
@@ -3357,9 +892,9 @@
 	return (ahd_print_register(NULL, 0, "LAST_MSG",
 	    0x14a, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ALTSTIM",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "MANUALP",		0x0c, 0x0c },
 	{ "ENRSELI",		0x10, 0x10 },
@@ -3380,9 +915,9 @@
 	return (ahd_print_register(NULL, 0, "INITIATOR_TAG",
 	    0x14c, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const ahd_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "PENDING_MK_MESSAGE",	0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 },
 	{ "SELECTOUT_QFROZEN",	0x04, 0x04 }
 };
@@ -3477,9 +1012,9 @@
 	return (ahd_print_register(NULL, 0, "SCB_RESIDUAL_DATACNT",
 	    0x180, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_RESIDUAL_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_OVERRUN_RESID",	0x02, 0x02 },
 	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
 };
@@ -3532,9 +1067,9 @@
 	return (ahd_print_register(NULL, 0, "SCB_TAG",
 	    0x190, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "SCB_TAG_TYPE",	0x03, 0x03 },
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "STATUS_RCVD",	0x08, 0x08 },
 	{ "MK_MESSAGE",		0x10, 0x10 },
@@ -3549,9 +1084,9 @@
 	return (ahd_print_register(SCB_CONTROL_parse_table, 7, "SCB_CONTROL",
 	    0x192, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "OID",		0x0f, 0x0f },
 	{ "TID",		0xf0, 0xf0 }
 };
 
@@ -3561,9 +1096,9 @@
 	return (ahd_print_register(SCB_SCSIID_parse_table, 2, "SCB_SCSIID",
 	    0x193, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "LID",		0xff, 0xff }
 };
 
 int
@@ -3572,9 +1107,9 @@
 	return (ahd_print_register(SCB_LUN_parse_table, 1, "SCB_LUN",
 	    0x194, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_TASK_ATTRIBUTE_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x01, 0x01 }
 };
 
 int
@@ -3583,9 +1118,9 @@
 	return (ahd_print_register(SCB_TASK_ATTRIBUTE_parse_table, 1, "SCB_TASK_ATTRIBUTE",
 	    0x195, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_CDB_LEN_parse_table[] = {
 	{ "SCB_CDB_LEN_PTR",	0x80, 0x80 }
 };
 
 int
@@ -3608,9 +1143,9 @@
 	return (ahd_print_register(NULL, 0, "SCB_DATAPTR",
 	    0x198, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f },
 	{ "SG_LAST_SEG",	0x80, 0x80 }
 };
 
@@ -3620,9 +1155,9 @@
 	return (ahd_print_register(SCB_DATACNT_parse_table, 2, "SCB_DATACNT",
 	    0x1a0, regvalue, cur_col, wrap));
 }
 
-static ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahd_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_STATUS_VALID",	0x04, 0x04 }
 };
--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic79xx_seq.h_shipped	Fri Apr 25 02:34:36 2008
@@ -4,9 +4,9 @@
  *
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.seq#120 $
  * $Id: //depot/aic7xxx/aic7xxx/aic79xx.reg#77 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xff, 0x02, 0x06, 0x78,
 	0x00, 0xea, 0x6e, 0x59,
 	0x01, 0xea, 0x04, 0x30,
 	0xff, 0x04, 0x0c, 0x78,
@@ -1026,9 +1026,9 @@
 {
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahd_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
 				 skip_patch	:12;
@@ -1165,9 +1165,9 @@
 	{ ahd_patch0_func, 807, 1, 1 },
 	{ ahd_patch23_func, 815, 11, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {
 	{ 17, 30 },
--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic7xxx_reg.h_shipped	Fri Apr 25 02:37:17 2008
@@ -26,22 +26,8 @@
     ahc_print_register(NULL, 0, "SXFRCTL0", 0x01, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl1_print;
-#else
-#define ahc_sxfrctl1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL1", 0x02, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsisigo_print;
-#else
-#define ahc_scsisigo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSISIGO", 0x03, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsisigi_print;
 #else
 #define ahc_scsisigi_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SCSISIGI", 0x03, regvalue, cur_col, wrap)
@@ -54,71 +40,15 @@
     ahc_print_register(NULL, 0, "SCSIRATE", 0x04, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiid_print;
-#else
-#define ahc_scsiid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIID", 0x05, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsidatl_print;
-#else
-#define ahc_scsidatl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIDATL", 0x06, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsidath_print;
-#else
-#define ahc_scsidath_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIDATH", 0x07, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_stcnt_print;
-#else
-#define ahc_stcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STCNT", 0x08, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_optionmode_print;
-#else
-#define ahc_optionmode_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "OPTIONMODE", 0x08, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_targcrccnt_print;
-#else
-#define ahc_targcrccnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TARGCRCCNT", 0x0a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrsint0_print;
-#else
-#define ahc_clrsint0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRSINT0", 0x0b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sstat0_print;
 #else
 #define ahc_sstat0_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SSTAT0", 0x0b, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrsint1_print;
-#else
-#define ahc_clrsint1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRSINT1", 0x0c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sstat1_print;
 #else
 #define ahc_sstat1_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SSTAT1", 0x0c, regvalue, cur_col, wrap)
@@ -138,15 +68,8 @@
     ahc_print_register(NULL, 0, "SSTAT3", 0x0e, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsiid_ultra2_print;
-#else
-#define ahc_scsiid_ultra2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIID_ULTRA2", 0x0f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_simode0_print;
 #else
 #define ahc_simode0_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SIMODE0", 0x10, regvalue, cur_col, wrap)
@@ -166,78 +89,8 @@
     ahc_print_register(NULL, 0, "SCSIBUSL", 0x12, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scsibush_print;
-#else
-#define ahc_scsibush_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCSIBUSH", 0x13, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sxfrctl2_print;
-#else
-#define ahc_sxfrctl2_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SXFRCTL2", 0x13, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_shaddr_print;
-#else
-#define ahc_shaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SHADDR", 0x14, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seltimer_print;
-#else
-#define ahc_seltimer_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SELTIMER", 0x18, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_selid_print;
-#else
-#define ahc_selid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SELID", 0x19, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scamctl_print;
-#else
-#define ahc_scamctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCAMCTL", 0x1a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_targid_print;
-#else
-#define ahc_targid_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "TARGID", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_spiocap_print;
-#else
-#define ahc_spiocap_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SPIOCAP", 0x1b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_brdctl_print;
-#else
-#define ahc_brdctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BRDCTL", 0x1d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seectl_print;
-#else
-#define ahc_seectl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEECTL", 0x1e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_sblkctl_print;
 #else
 #define ahc_sblkctl_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SBLKCTL", 0x1f, regvalue, cur_col, wrap)
@@ -481,106 +334,8 @@
     ahc_print_register(NULL, 0, "SEQCTL", 0x60, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqram_print;
-#else
-#define ahc_seqram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQRAM", 0x61, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqaddr0_print;
-#else
-#define ahc_seqaddr0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQADDR0", 0x62, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seqaddr1_print;
-#else
-#define ahc_seqaddr1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEQADDR1", 0x63, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_accum_print;
-#else
-#define ahc_accum_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ACCUM", 0x64, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sindex_print;
-#else
-#define ahc_sindex_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SINDEX", 0x65, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dindex_print;
-#else
-#define ahc_dindex_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DINDEX", 0x66, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_allones_print;
-#else
-#define ahc_allones_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ALLONES", 0x69, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_allzeros_print;
-#else
-#define ahc_allzeros_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "ALLZEROS", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_none_print;
-#else
-#define ahc_none_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "NONE", 0x6a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_flags_print;
-#else
-#define ahc_flags_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "FLAGS", 0x6b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sindir_print;
-#else
-#define ahc_sindir_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SINDIR", 0x6c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dindir_print;
-#else
-#define ahc_dindir_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DINDIR", 0x6d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_function1_print;
-#else
-#define ahc_function1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "FUNCTION1", 0x6e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_stack_print;
-#else
-#define ahc_stack_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STACK", 0x6f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_targ_offset_print;
 #else
 #define ahc_targ_offset_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "TARG_OFFSET", 0x70, regvalue, cur_col, wrap)
@@ -593,99 +348,8 @@
     ahc_print_register(NULL, 0, "SRAM_BASE", 0x70, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_bctl_print;
-#else
-#define ahc_bctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BCTL", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dscommand0_print;
-#else
-#define ahc_dscommand0_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSCOMMAND0", 0x84, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_bustime_print;
-#else
-#define ahc_bustime_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BUSTIME", 0x85, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dscommand1_print;
-#else
-#define ahc_dscommand1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSCOMMAND1", 0x85, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_busspd_print;
-#else
-#define ahc_busspd_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "BUSSPD", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hs_mailbox_print;
-#else
-#define ahc_hs_mailbox_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HS_MAILBOX", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dspcistatus_print;
-#else
-#define ahc_dspcistatus_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DSPCISTATUS", 0x86, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hcntrl_print;
-#else
-#define ahc_hcntrl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HCNTRL", 0x87, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_haddr_print;
-#else
-#define ahc_haddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HADDR", 0x88, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hcnt_print;
-#else
-#define ahc_hcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HCNT", 0x8c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbptr_print;
-#else
-#define ahc_scbptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBPTR", 0x90, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_intstat_print;
-#else
-#define ahc_intstat_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "INTSTAT", 0x91, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_clrint_print;
-#else
-#define ahc_clrint_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CLRINT", 0x92, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_error_print;
 #else
 #define ahc_error_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "ERROR", 0x92, regvalue, cur_col, wrap)
@@ -705,85 +369,15 @@
     ahc_print_register(NULL, 0, "DFSTATUS", 0x94, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfwaddr_print;
-#else
-#define ahc_dfwaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFWADDR", 0x95, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfraddr_print;
-#else
-#define ahc_dfraddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFRADDR", 0x97, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dfdat_print;
-#else
-#define ahc_dfdat_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFDAT", 0x99, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbcnt_print;
-#else
-#define ahc_scbcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBCNT", 0x9a, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qinfifo_print;
-#else
-#define ahc_qinfifo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QINFIFO", 0x9b, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qincnt_print;
-#else
-#define ahc_qincnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QINCNT", 0x9c, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoutfifo_print;
-#else
-#define ahc_qoutfifo_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOUTFIFO", 0x9d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_crccontrol1_print;
-#else
-#define ahc_crccontrol1_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CRCCONTROL1", 0x9d, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoutcnt_print;
-#else
-#define ahc_qoutcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOUTCNT", 0x9e, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scsiphase_print;
 #else
 #define ahc_scsiphase_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SCSIPHASE", 0x9e, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sfunct_print;
-#else
-#define ahc_sfunct_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SFUNCT", 0x9f, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scb_base_print;
 #else
 #define ahc_scb_base_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SCB_BASE", 0xa0, regvalue, cur_col, wrap)
@@ -915,152 +509,12 @@
     ahc_print_register(NULL, 0, "SCB_64_SPARE", 0xc0, regvalue, cur_col, wrap)
 #endif
 
 #if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_seectl_2840_print;
-#else
-#define ahc_seectl_2840_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SEECTL_2840", 0xc0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_status_2840_print;
-#else
-#define ahc_status_2840_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "STATUS_2840", 0xc1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
 ahc_reg_print_t ahc_scb_64_btt_print;
 #else
 #define ahc_scb_64_btt_print(regvalue, cur_col, wrap) \
     ahc_print_register(NULL, 0, "SCB_64_BTT", 0xd0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_cchaddr_print;
-#else
-#define ahc_cchaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCHADDR", 0xe0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_cchcnt_print;
-#else
-#define ahc_cchcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCHCNT", 0xe8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgram_print;
-#else
-#define ahc_ccsgram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGRAM", 0xe9, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgaddr_print;
-#else
-#define ahc_ccsgaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGADDR", 0xea, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccsgctl_print;
-#else
-#define ahc_ccsgctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSGCTL", 0xeb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbram_print;
-#else
-#define ahc_ccscbram_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBRAM", 0xec, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbaddr_print;
-#else
-#define ahc_ccscbaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBADDR", 0xed, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbctl_print;
-#else
-#define ahc_ccscbctl_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBCTL", 0xee, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbcnt_print;
-#else
-#define ahc_ccscbcnt_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBCNT", 0xef, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_scbbaddr_print;
-#else
-#define ahc_scbbaddr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SCBBADDR", 0xf0, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_ccscbptr_print;
-#else
-#define ahc_ccscbptr_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "CCSCBPTR", 0xf1, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_hnscb_qoff_print;
-#else
-#define ahc_hnscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "HNSCB_QOFF", 0xf4, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_snscb_qoff_print;
-#else
-#define ahc_snscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SNSCB_QOFF", 0xf6, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sdscb_qoff_print;
-#else
-#define ahc_sdscb_qoff_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SDSCB_QOFF", 0xf8, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_qoff_ctlsta_print;
-#else
-#define ahc_qoff_ctlsta_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "QOFF_CTLSTA", 0xfa, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_dff_thrsh_print;
-#else
-#define ahc_dff_thrsh_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "DFF_THRSH", 0xfb, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sg_cache_shadow_print;
-#else
-#define ahc_sg_cache_shadow_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SG_CACHE_SHADOW", 0xfc, regvalue, cur_col, wrap)
-#endif
-
-#if AIC_DEBUG_REGISTERS
-ahc_reg_print_t ahc_sg_cache_pre_print;
-#else
-#define ahc_sg_cache_pre_print(regvalue, cur_col, wrap) \
-    ahc_print_register(NULL, 0, "SG_CACHE_PRE", 0xfc, regvalue, cur_col, wrap)
 #endif
 
 
 #define	SCSISEQ         		0x00
--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic7xxx_reg_print.c_shipped	Fri Apr 25 02:37:17 2008
@@ -7,9 +7,9 @@
  */
 
 #include "aic7xxx_osm.h"
 
-static ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISEQ_parse_table[] = {
 	{ "SCSIRSTO",		0x01, 0x01 },
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
 	{ "ENAUTOATNO",		0x08, 0x08 },
@@ -25,9 +25,9 @@
 	return (ahc_print_register(SCSISEQ_parse_table, 8, "SCSISEQ",
 	    0x00, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
+static const ahc_reg_parse_entry_t SXFRCTL0_parse_table[] = {
 	{ "CLRCHN",		0x02, 0x02 },
 	{ "SCAMEN",		0x04, 0x04 },
 	{ "SPIOEN",		0x08, 0x08 },
 	{ "CLRSTCNT",		0x10, 0x10 },
@@ -42,51 +42,9 @@
 	return (ahc_print_register(SXFRCTL0_parse_table, 7, "SXFRCTL0",
 	    0x01, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SXFRCTL1_parse_table[] = {
-	{ "STPWEN",		0x01, 0x01 },
-	{ "ACTNEGEN",		0x02, 0x02 },
-	{ "ENSTIMER",		0x04, 0x04 },
-	{ "ENSPCHK",		0x20, 0x20 },
-	{ "SWRAPEN",		0x40, 0x40 },
-	{ "BITBUCKET",		0x80, 0x80 },
-	{ "STIMESEL",		0x18, 0x18 }
-};
-
-int
-ahc_sxfrctl1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SXFRCTL1_parse_table, 7, "SXFRCTL1",
-	    0x02, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSISIGO_parse_table[] = {
-	{ "ACKO",		0x01, 0x01 },
-	{ "REQO",		0x02, 0x02 },
-	{ "BSYO",		0x04, 0x04 },
-	{ "SELO",		0x08, 0x08 },
-	{ "ATNO",		0x10, 0x10 },
-	{ "MSGO",		0x20, 0x20 },
-	{ "IOO",		0x40, 0x40 },
-	{ "CDO",		0x80, 0x80 },
-	{ "P_DATAOUT",		0x00, 0x00 },
-	{ "P_DATAIN",		0x40, 0x40 },
-	{ "P_COMMAND",		0x80, 0x80 },
-	{ "P_MESGOUT",		0xa0, 0xa0 },
-	{ "P_STATUS",		0xc0, 0xc0 },
-	{ "PHASE_MASK",		0xe0, 0xe0 },
-	{ "P_MESGIN",		0xe0, 0xe0 }
-};
-
-int
-ahc_scsisigo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSISIGO_parse_table, 15, "SCSISIGO",
-	    0x03, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISIGI_parse_table[] = {
 	{ "ACKI",		0x01, 0x01 },
 	{ "REQI",		0x02, 0x02 },
 	{ "BSYI",		0x04, 0x04 },
 	{ "SELI",		0x08, 0x08 },
@@ -111,9 +69,9 @@
 	return (ahc_print_register(SCSISIGI_parse_table, 17, "SCSISIGI",
 	    0x03, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSIRATE_parse_table[] = {
 	{ "SINGLE_EDGE",	0x10, 0x10 },
 	{ "ENABLE_CRC",		0x40, 0x40 },
 	{ "WIDEXFER",		0x80, 0x80 },
 	{ "SXFR_ULTRA2",	0x0f, 0x0f },
@@ -127,87 +85,9 @@
 	return (ahc_print_register(SCSIRATE_parse_table, 6, "SCSIRATE",
 	    0x04, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIID_parse_table[] = {
-	{ "TWIN_CHNLB",		0x80, 0x80 },
-	{ "OID",		0x0f, 0x0f },
-	{ "TWIN_TID",		0x70, 0x70 },
-	{ "SOFS_ULTRA2",	0x7f, 0x7f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahc_scsiid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIID_parse_table, 5, "SCSIID",
-	    0x05, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scsidatl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIDATL",
-	    0x06, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scsidath_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCSIDATH",
-	    0x07, regvalue, cur_col, wrap));
-}
-
-int
-ahc_stcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "STCNT",
-	    0x08, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t OPTIONMODE_parse_table[] = {
-	{ "DIS_MSGIN_DUALEDGE",	0x01, 0x01 },
-	{ "AUTO_MSGOUT_DE",	0x02, 0x02 },
-	{ "SCSIDATL_IMGEN",	0x04, 0x04 },
-	{ "EXPPHASEDIS",	0x08, 0x08 },
-	{ "BUSFREEREV",		0x10, 0x10 },
-	{ "ATNMGMNTEN",		0x20, 0x20 },
-	{ "AUTOACKEN",		0x40, 0x40 },
-	{ "AUTORATEEN",		0x80, 0x80 },
-	{ "OPTIONMODE_DEFAULTS",0x03, 0x03 }
-};
-
-int
-ahc_optionmode_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(OPTIONMODE_parse_table, 9, "OPTIONMODE",
-	    0x08, regvalue, cur_col, wrap));
-}
-
-int
-ahc_targcrccnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "TARGCRCCNT",
-	    0x0a, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CLRSINT0_parse_table[] = {
-	{ "CLRSPIORDY",		0x02, 0x02 },
-	{ "CLRSWRAP",		0x08, 0x08 },
-	{ "CLRIOERR",		0x08, 0x08 },
-	{ "CLRSELINGO",		0x10, 0x10 },
-	{ "CLRSELDI",		0x20, 0x20 },
-	{ "CLRSELDO",		0x40, 0x40 }
-};
-
-int
-ahc_clrsint0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRSINT0_parse_table, 6, "CLRSINT0",
-	    0x0b, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT0_parse_table[] = {
 	{ "DMADONE",		0x01, 0x01 },
 	{ "SPIORDY",		0x02, 0x02 },
 	{ "SDONE",		0x04, 0x04 },
 	{ "SWRAP",		0x08, 0x08 },
@@ -224,26 +104,9 @@
 	return (ahc_print_register(SSTAT0_parse_table, 9, "SSTAT0",
 	    0x0b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t CLRSINT1_parse_table[] = {
-	{ "CLRREQINIT",		0x01, 0x01 },
-	{ "CLRPHASECHG",	0x02, 0x02 },
-	{ "CLRSCSIPERR",	0x04, 0x04 },
-	{ "CLRBUSFREE",		0x08, 0x08 },
-	{ "CLRSCSIRSTI",	0x20, 0x20 },
-	{ "CLRATNO",		0x40, 0x40 },
-	{ "CLRSELTIMEO",	0x80, 0x80 }
-};
-
-int
-ahc_clrsint1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRSINT1_parse_table, 7, "CLRSINT1",
-	    0x0c, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT1_parse_table[] = {
 	{ "REQINIT",		0x01, 0x01 },
 	{ "PHASECHG",		0x02, 0x02 },
 	{ "SCSIPERR",		0x04, 0x04 },
 	{ "BUSFREE",		0x08, 0x08 },
@@ -259,9 +122,9 @@
 	return (ahc_print_register(SSTAT1_parse_table, 8, "SSTAT1",
 	    0x0c, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT2_parse_table[] = {
 	{ "DUAL_EDGE_ERR",	0x01, 0x01 },
 	{ "CRCREQERR",		0x02, 0x02 },
 	{ "CRCENDERR",		0x04, 0x04 },
 	{ "CRCVALERR",		0x08, 0x08 },
@@ -277,9 +140,9 @@
 	return (ahc_print_register(SSTAT2_parse_table, 8, "SSTAT2",
 	    0x0d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
+static const ahc_reg_parse_entry_t SSTAT3_parse_table[] = {
 	{ "OFFCNT",		0x0f, 0x0f },
 	{ "U2OFFCNT",		0x7f, 0x7f },
 	{ "SCSICNT",		0xf0, 0xf0 }
 };
@@ -290,21 +153,9 @@
 	return (ahc_print_register(SSTAT3_parse_table, 3, "SSTAT3",
 	    0x0e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSIID_ULTRA2_parse_table[] = {
-	{ "OID",		0x0f, 0x0f },
-	{ "TID",		0xf0, 0xf0 }
-};
-
-int
-ahc_scsiid_ultra2_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCSIID_ULTRA2_parse_table, 2, "SCSIID_ULTRA2",
-	    0x0f, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
+static const ahc_reg_parse_entry_t SIMODE0_parse_table[] = {
 	{ "ENDMADONE",		0x01, 0x01 },
 	{ "ENSPIORDY",		0x02, 0x02 },
 	{ "ENSDONE",		0x04, 0x04 },
 	{ "ENSWRAP",		0x08, 0x08 },
@@ -320,9 +171,9 @@
 	return (ahc_print_register(SIMODE0_parse_table, 8, "SIMODE0",
 	    0x10, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
+static const ahc_reg_parse_entry_t SIMODE1_parse_table[] = {
 	{ "ENREQINIT",		0x01, 0x01 },
 	{ "ENPHASECHG",		0x02, 0x02 },
 	{ "ENSCSIPERR",		0x04, 0x04 },
 	{ "ENBUSFREE",		0x08, 0x08 },
@@ -345,145 +196,9 @@
 	return (ahc_print_register(NULL, 0, "SCSIBUSL",
 	    0x12, regvalue, cur_col, wrap));
 }
 
-int
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
-ahc_shaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SHADDR",
-	    0x14, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SELTIMER_parse_table[] = {
-	{ "STAGE1",		0x01, 0x01 },
-	{ "STAGE2",		0x02, 0x02 },
-	{ "STAGE3",		0x04, 0x04 },
-	{ "STAGE4",		0x08, 0x08 },
-	{ "STAGE5",		0x10, 0x10 },
-	{ "STAGE6",		0x20, 0x20 }
-};
-
-int
-ahc_seltimer_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SELTIMER_parse_table, 6, "SELTIMER",
-	    0x18, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SELID_parse_table[] = {
-	{ "ONEBIT",		0x08, 0x08 },
-	{ "SELID_MASK",		0xf0, 0xf0 }
-};
-
-int
-ahc_selid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SELID_parse_table, 2, "SELID",
-	    0x19, regvalue, cur_col, wrap));
-}
-
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
-int
-ahc_targid_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "TARGID",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SPIOCAP_parse_table[] = {
-	{ "SSPIOCPS",		0x01, 0x01 },
-	{ "ROM",		0x02, 0x02 },
-	{ "EEPROM",		0x04, 0x04 },
-	{ "SEEPROM",		0x08, 0x08 },
-	{ "EXT_BRDCTL",		0x10, 0x10 },
-	{ "SOFTCMDEN",		0x20, 0x20 },
-	{ "SOFT0",		0x40, 0x40 },
-	{ "SOFT1",		0x80, 0x80 }
-};
-
-int
-ahc_spiocap_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SPIOCAP_parse_table, 8, "SPIOCAP",
-	    0x1b, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t BRDCTL_parse_table[] = {
-	{ "BRDCTL0",		0x01, 0x01 },
-	{ "BRDSTB_ULTRA2",	0x01, 0x01 },
-	{ "BRDCTL1",		0x02, 0x02 },
-	{ "BRDRW_ULTRA2",	0x02, 0x02 },
-	{ "BRDRW",		0x04, 0x04 },
-	{ "BRDDAT2",		0x04, 0x04 },
-	{ "BRDCS",		0x08, 0x08 },
-	{ "BRDDAT3",		0x08, 0x08 },
-	{ "BRDSTB",		0x10, 0x10 },
-	{ "BRDDAT4",		0x10, 0x10 },
-	{ "BRDDAT5",		0x20, 0x20 },
-	{ "BRDDAT6",		0x40, 0x40 },
-	{ "BRDDAT7",		0x80, 0x80 }
-};
-
-int
-ahc_brdctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BRDCTL_parse_table, 13, "BRDCTL",
-	    0x1d, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SEECTL_parse_table[] = {
-	{ "SEEDI",		0x01, 0x01 },
-	{ "SEEDO",		0x02, 0x02 },
-	{ "SEECK",		0x04, 0x04 },
-	{ "SEECS",		0x08, 0x08 },
-	{ "SEERDY",		0x10, 0x10 },
-	{ "SEEMS",		0x20, 0x20 },
-	{ "EXTARBREQ",		0x40, 0x40 },
-	{ "EXTARBACK",		0x80, 0x80 }
-};
-
-int
-ahc_seectl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEECTL_parse_table, 8, "SEECTL",
-	    0x1e, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SBLKCTL_parse_table[] = {
 	{ "XCVR",		0x01, 0x01 },
 	{ "SELWIDE",		0x02, 0x02 },
 	{ "ENAB20",		0x04, 0x04 },
 	{ "SELBUSB",		0x08, 0x08 },
@@ -548,9 +263,9 @@
 	return (ahc_print_register(NULL, 0, "MSG_OUT",
 	    0x3a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
+static const ahc_reg_parse_entry_t DMAPARAMS_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
 	{ "HDMAEN",		0x08, 0x08 },
@@ -568,9 +283,9 @@
 	return (ahc_print_register(DMAPARAMS_parse_table, 10, "DMAPARAMS",
 	    0x3b, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQ_FLAGS_parse_table[] = {
 	{ "NO_DISCONNECT",	0x01, 0x01 },
 	{ "SPHASE_PENDING",	0x02, 0x02 },
 	{ "DPHASE_PENDING",	0x04, 0x04 },
 	{ "CMDPHASE_PENDING",	0x08, 0x08 },
@@ -601,9 +316,9 @@
 	return (ahc_print_register(NULL, 0, "SAVED_LUN",
 	    0x3e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
+static const ahc_reg_parse_entry_t LASTPHASE_parse_table[] = {
 	{ "MSGI",		0x20, 0x20 },
 	{ "IOI",		0x40, 0x40 },
 	{ "CDI",		0x80, 0x80 },
 	{ "P_DATAOUT",		0x00, 0x00 },
@@ -699,9 +414,9 @@
 	return (ahc_print_register(NULL, 0, "TQINPOS",
 	    0x50, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t ARG_1_parse_table[] = {
+static const ahc_reg_parse_entry_t ARG_1_parse_table[] = {
 	{ "CONT_TARG_SESSION",	0x02, 0x02 },
 	{ "CONT_MSG_LOOP",	0x04, 0x04 },
 	{ "EXIT_MSG_LOOP",	0x08, 0x08 },
 	{ "MSGOUT_PHASEMIS",	0x10, 0x10 },
@@ -730,9 +445,9 @@
 	return (ahc_print_register(NULL, 0, "LAST_MSG",
 	    0x53, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSISEQ_TEMPLATE_parse_table[] = {
 	{ "ENAUTOATNP",		0x02, 0x02 },
 	{ "ENAUTOATNI",		0x04, 0x04 },
 	{ "ENAUTOATNO",		0x08, 0x08 },
 	{ "ENRSELI",		0x10, 0x10 },
@@ -746,9 +461,9 @@
 	return (ahc_print_register(SCSISEQ_TEMPLATE_parse_table, 6, "SCSISEQ_TEMPLATE",
 	    0x54, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSGLOBAL_parse_table[] = {
 	{ "HA_274_EXTENDED_TRANS",0x01, 0x01 }
 };
 
 int
@@ -757,9 +472,9 @@
 	return (ahc_print_register(HA_274_BIOSGLOBAL_parse_table, 1, "HA_274_BIOSGLOBAL",
 	    0x56, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQ_FLAGS2_parse_table[] = {
 	{ "SCB_DMA",		0x01, 0x01 },
 	{ "TARGET_MSG_PENDING",	0x02, 0x02 }
 };
 
@@ -769,9 +484,9 @@
 	return (ahc_print_register(SEQ_FLAGS2_parse_table, 2, "SEQ_FLAGS2",
 	    0x57, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
+static const ahc_reg_parse_entry_t SCSICONF_parse_table[] = {
 	{ "ENSPCHK",		0x20, 0x20 },
 	{ "RESET_SCSI",		0x40, 0x40 },
 	{ "TERM_ENB",		0x80, 0x80 },
 	{ "HSCSIID",		0x07, 0x07 },
@@ -784,9 +499,9 @@
 	return (ahc_print_register(SCSICONF_parse_table, 5, "SCSICONF",
 	    0x5a, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t INTDEF_parse_table[] = {
+static const ahc_reg_parse_entry_t INTDEF_parse_table[] = {
 	{ "EDGE_TRIG",		0x80, 0x80 },
 	{ "VECTOR",		0x0f, 0x0f }
 };
 
@@ -803,9 +518,9 @@
 	return (ahc_print_register(NULL, 0, "HOSTCONF",
 	    0x5d, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t HA_274_BIOSCTRL_parse_table[] = {
 	{ "CHANNEL_B_PRIMARY",	0x08, 0x08 },
 	{ "BIOSMODE",		0x30, 0x30 },
 	{ "BIOSDISABLED",	0x30, 0x30 }
 };
@@ -816,9 +531,9 @@
 	return (ahc_print_register(HA_274_BIOSCTRL_parse_table, 3, "HA_274_BIOSCTRL",
 	    0x5f, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
+static const ahc_reg_parse_entry_t SEQCTL_parse_table[] = {
 	{ "LOADRAM",		0x01, 0x01 },
 	{ "SEQRESET",		0x02, 0x02 },
 	{ "STEP",		0x04, 0x04 },
 	{ "BRKADRINTEN",	0x08, 0x08 },
@@ -835,115 +550,8 @@
 	    0x60, regvalue, cur_col, wrap));
 }
 
 int
-ahc_seqram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SEQRAM",
-	    0x61, regvalue, cur_col, wrap));
-}
-
-int
-ahc_seqaddr0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SEQADDR0",
-	    0x62, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SEQADDR1_parse_table[] = {
-	{ "SEQADDR1_MASK",	0x01, 0x01 }
-};
-
-int
-ahc_seqaddr1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEQADDR1_parse_table, 1, "SEQADDR1",
-	    0x63, regvalue, cur_col, wrap));
-}
-
-int
-ahc_accum_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ACCUM",
-	    0x64, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SINDEX",
-	    0x65, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dindex_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DINDEX",
-	    0x66, regvalue, cur_col, wrap));
-}
-
-int
-ahc_allones_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ALLONES",
-	    0x69, regvalue, cur_col, wrap));
-}
-
-int
-ahc_allzeros_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "ALLZEROS",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
-int
-ahc_none_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "NONE",
-	    0x6a, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t FLAGS_parse_table[] = {
-	{ "CARRY",		0x01, 0x01 },
-	{ "ZERO",		0x02, 0x02 }
-};
-
-int
-ahc_flags_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(FLAGS_parse_table, 2, "FLAGS",
-	    0x6b, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SINDIR",
-	    0x6c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dindir_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DINDIR",
-	    0x6d, regvalue, cur_col, wrap));
-}
-
-int
-ahc_function1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "FUNCTION1",
-	    0x6e, regvalue, cur_col, wrap));
-}
-
-int
-ahc_stack_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "STACK",
-	    0x6f, regvalue, cur_col, wrap));
-}
-
-int
 ahc_targ_offset_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "TARG_OFFSET",
 	    0x70, regvalue, cur_col, wrap));
@@ -955,187 +563,9 @@
 	return (ahc_print_register(NULL, 0, "SRAM_BASE",
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
-	{ "CIOPARCKEN",		0x01, 0x01 },
-	{ "USCBSIZE32",		0x02, 0x02 },
-	{ "RAMPS",		0x04, 0x04 },
-	{ "INTSCBRAMSEL",	0x08, 0x08 },
-	{ "EXTREQLCK",		0x10, 0x10 },
-	{ "MPARCKEN",		0x20, 0x20 },
-	{ "DPARCKEN",		0x40, 0x40 },
-	{ "CACHETHEN",		0x80, 0x80 }
-};
-
-int
-ahc_dscommand0_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSCOMMAND0_parse_table, 8, "DSCOMMAND0",
-	    0x84, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t BUSTIME_parse_table[] = {
-	{ "BON",		0x0f, 0x0f },
-	{ "BOFF",		0xf0, 0xf0 }
-};
-
-int
-ahc_bustime_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BUSTIME_parse_table, 2, "BUSTIME",
-	    0x85, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DSCOMMAND1_parse_table[] = {
-	{ "HADDLDSEL0",		0x01, 0x01 },
-	{ "HADDLDSEL1",		0x02, 0x02 },
-	{ "DSLATT",		0xfc, 0xfc }
-};
-
-int
-ahc_dscommand1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSCOMMAND1_parse_table, 3, "DSCOMMAND1",
-	    0x85, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t BUSSPD_parse_table[] = {
-	{ "STBON",		0x07, 0x07 },
-	{ "STBOFF",		0x38, 0x38 },
-	{ "DFTHRSH_75",		0x80, 0x80 },
-	{ "DFTHRSH",		0xc0, 0xc0 },
-	{ "DFTHRSH_100",	0xc0, 0xc0 }
-};
-
-int
-ahc_busspd_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(BUSSPD_parse_table, 5, "BUSSPD",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t HS_MAILBOX_parse_table[] = {
-	{ "SEQ_MAILBOX",	0x0f, 0x0f },
-	{ "HOST_TQINPOS",	0x80, 0x80 },
-	{ "HOST_MAILBOX",	0xf0, 0xf0 }
-};
-
-int
-ahc_hs_mailbox_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HS_MAILBOX_parse_table, 3, "HS_MAILBOX",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DSPCISTATUS_parse_table[] = {
-	{ "DFTHRSH_100",	0xc0, 0xc0 }
-};
-
-int
-ahc_dspcistatus_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DSPCISTATUS_parse_table, 1, "DSPCISTATUS",
-	    0x86, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t HCNTRL_parse_table[] = {
-	{ "CHIPRST",		0x01, 0x01 },
-	{ "CHIPRSTACK",		0x01, 0x01 },
-	{ "INTEN",		0x02, 0x02 },
-	{ "PAUSE",		0x04, 0x04 },
-	{ "IRQMS",		0x08, 0x08 },
-	{ "SWINT",		0x10, 0x10 },
-	{ "POWRDN",		0x40, 0x40 }
-};
-
-int
-ahc_hcntrl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(HCNTRL_parse_table, 7, "HCNTRL",
-	    0x87, regvalue, cur_col, wrap));
-}
-
-int
-ahc_haddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HADDR",
-	    0x88, regvalue, cur_col, wrap));
-}
-
-int
-ahc_hcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HCNT",
-	    0x8c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCBPTR",
-	    0x90, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t INTSTAT_parse_table[] = {
-	{ "SEQINT",		0x01, 0x01 },
-	{ "CMDCMPLT",		0x02, 0x02 },
-	{ "SCSIINT",		0x04, 0x04 },
-	{ "BRKADRINT",		0x08, 0x08 },
-	{ "BAD_PHASE",		0x01, 0x01 },
-	{ "INT_PEND",		0x0f, 0x0f },
-	{ "SEND_REJECT",	0x11, 0x11 },
-	{ "PROTO_VIOLATION",	0x21, 0x21 },
-	{ "NO_MATCH",		0x31, 0x31 },
-	{ "IGN_WIDE_RES",	0x41, 0x41 },
-	{ "PDATA_REINIT",	0x51, 0x51 },
-	{ "HOST_MSG_LOOP",	0x61, 0x61 },
-	{ "BAD_STATUS",		0x71, 0x71 },
-	{ "PERR_DETECTED",	0x81, 0x81 },
-	{ "DATA_OVERRUN",	0x91, 0x91 },
-	{ "MKMSG_FAILED",	0xa1, 0xa1 },
-	{ "MISSED_BUSFREE",	0xb1, 0xb1 },
-	{ "SCB_MISMATCH",	0xc1, 0xc1 },
-	{ "NO_FREE_SCB",	0xd1, 0xd1 },
-	{ "OUT_OF_RANGE",	0xe1, 0xe1 },
-	{ "SEQINT_MASK",	0xf1, 0xf1 }
-};
-
-int
-ahc_intstat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(INTSTAT_parse_table, 21, "INTSTAT",
-	    0x91, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CLRINT_parse_table[] = {
-	{ "CLRSEQINT",		0x01, 0x01 },
-	{ "CLRCMDINT",		0x02, 0x02 },
-	{ "CLRSCSIINT",		0x04, 0x04 },
-	{ "CLRBRKADRINT",	0x08, 0x08 },
-	{ "CLRPARERR",		0x10, 0x10 }
-};
-
-int
-ahc_clrint_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CLRINT_parse_table, 5, "CLRINT",
-	    0x92, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t ERROR_parse_table[] = {
+static const ahc_reg_parse_entry_t ERROR_parse_table[] = {
 	{ "ILLHADDR",		0x01, 0x01 },
 	{ "ILLSADDR",		0x02, 0x02 },
 	{ "ILLOPCODE",		0x04, 0x04 },
 	{ "SQPARERR",		0x08, 0x08 },
@@ -1151,9 +581,9 @@
 	return (ahc_print_register(ERROR_parse_table, 8, "ERROR",
 	    0x92, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
+static const ahc_reg_parse_entry_t DFCNTRL_parse_table[] = {
 	{ "FIFORESET",		0x01, 0x01 },
 	{ "FIFOFLUSH",		0x02, 0x02 },
 	{ "DIRECTION",		0x04, 0x04 },
 	{ "HDMAEN",		0x08, 0x08 },
@@ -1171,9 +601,9 @@
 	return (ahc_print_register(DFCNTRL_parse_table, 10, "DFCNTRL",
 	    0x93, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
+static const ahc_reg_parse_entry_t DFSTATUS_parse_table[] = {
 	{ "FIFOEMP",		0x01, 0x01 },
 	{ "FIFOFULL",		0x02, 0x02 },
 	{ "DFTHRESH",		0x04, 0x04 },
 	{ "HDONE",		0x08, 0x08 },
@@ -1189,86 +619,9 @@
 	return (ahc_print_register(DFSTATUS_parse_table, 8, "DFSTATUS",
 	    0x94, regvalue, cur_col, wrap));
 }
 
-int
-ahc_dfwaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFWADDR",
-	    0x95, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dfraddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFRADDR",
-	    0x97, regvalue, cur_col, wrap));
-}
-
-int
-ahc_dfdat_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "DFDAT",
-	    0x99, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SCBCNT_parse_table[] = {
-	{ "SCBAUTO",		0x80, 0x80 },
-	{ "SCBCNT_MASK",	0x1f, 0x1f }
-};
-
-int
-ahc_scbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SCBCNT_parse_table, 2, "SCBCNT",
-	    0x9a, regvalue, cur_col, wrap));
-}
-
-int
-ahc_qinfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QINFIFO",
-	    0x9b, regvalue, cur_col, wrap));
-}
-
-int
-ahc_qincnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QINCNT",
-	    0x9c, regvalue, cur_col, wrap));
-}
-
-int
-ahc_qoutfifo_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "QOUTFIFO",
-	    0x9d, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CRCCONTROL1_parse_table[] = {
-	{ "TARGCRCCNTEN",	0x04, 0x04 },
-	{ "TARGCRCENDEN",	0x08, 0x08 },
-	{ "CRCREQCHKEN",	0x10, 0x10 },
-	{ "CRCENDCHKEN",	0x20, 0x20 },
-	{ "CRCVALCHKEN",	0x40, 0x40 },
-	{ "CRCONSEEN",		0x80, 0x80 }
-};
-
-int
-ahc_crccontrol1_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CRCCONTROL1_parse_table, 6, "CRCCONTROL1",
-	    0x9d, regvalue, cur_col, wrap));
-}
-
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
 	{ "MSG_IN_PHASE",	0x08, 0x08 },
@@ -1283,20 +636,9 @@
 	return (ahc_print_register(SCSIPHASE_parse_table, 7, "SCSIPHASE",
 	    0x9e, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SFUNCT_parse_table[] = {
-	{ "ALT_MODE",		0x80, 0x80 }
-};
-
 int
-ahc_sfunct_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SFUNCT_parse_table, 1, "SFUNCT",
-	    0x9f, regvalue, cur_col, wrap));
-}
-
-int
 ahc_scb_base_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "SCB_BASE",
 	    0xa0, regvalue, cur_col, wrap));
@@ -1350,9 +692,9 @@
 	return (ahc_print_register(NULL, 0, "SCB_DATAPTR",
 	    0xac, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_DATACNT_parse_table[] = {
 	{ "SG_LAST_SEG",	0x80, 0x80 },
 	{ "SG_HIGH_ADDR_BITS",	0x7f, 0x7f }
 };
 
@@ -1362,9 +704,9 @@
 	return (ahc_print_register(SCB_DATACNT_parse_table, 2, "SCB_DATACNT",
 	    0xb0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_SGPTR_parse_table[] = {
 	{ "SG_LIST_NULL",	0x01, 0x01 },
 	{ "SG_FULL_RESID",	0x02, 0x02 },
 	{ "SG_RESID_VALID",	0x04, 0x04 }
 };
@@ -1375,9 +717,9 @@
 	return (ahc_print_register(SCB_SGPTR_parse_table, 3, "SCB_SGPTR",
 	    0xb4, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_CONTROL_parse_table[] = {
 	{ "DISCONNECTED",	0x04, 0x04 },
 	{ "ULTRAENB",		0x08, 0x08 },
 	{ "MK_MESSAGE",		0x10, 0x10 },
 	{ "TAG_ENB",		0x20, 0x20 },
@@ -1393,9 +735,9 @@
 	return (ahc_print_register(SCB_CONTROL_parse_table, 8, "SCB_CONTROL",
 	    0xb8, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_SCSIID_parse_table[] = {
 	{ "TWIN_CHNLB",		0x80, 0x80 },
 	{ "OID",		0x0f, 0x0f },
 	{ "TWIN_TID",		0x70, 0x70 },
 	{ "TID",		0xf0, 0xf0 }
@@ -1407,9 +749,9 @@
 	return (ahc_print_register(SCB_SCSIID_parse_table, 4, "SCB_SCSIID",
 	    0xb9, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
+static const ahc_reg_parse_entry_t SCB_LUN_parse_table[] = {
 	{ "SCB_XFERLEN_ODD",	0x80, 0x80 },
 	{ "LID",		0x3f, 0x3f }
 };
 
@@ -1461,221 +803,11 @@
 	return (ahc_print_register(NULL, 0, "SCB_64_SPARE",
 	    0xc0, regvalue, cur_col, wrap));
 }
 
-static ahc_reg_parse_entry_t SEECTL_2840_parse_table[] = {
-	{ "DO_2840",		0x01, 0x01 },
-	{ "CK_2840",		0x02, 0x02 },
-	{ "CS_2840",		0x04, 0x04 }
-};
-
 int
-ahc_seectl_2840_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SEECTL_2840_parse_table, 3, "SEECTL_2840",
-	    0xc0, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t STATUS_2840_parse_table[] = {
-	{ "DI_2840",		0x01, 0x01 },
-	{ "EEPROM_TF",		0x80, 0x80 },
-	{ "ADSEL",		0x1e, 0x1e },
-	{ "BIOS_SEL",		0x60, 0x60 }
-};
-
-int
-ahc_status_2840_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(STATUS_2840_parse_table, 4, "STATUS_2840",
-	    0xc1, regvalue, cur_col, wrap));
-}
-
-int
 ahc_scb_64_btt_print(u_int regvalue, u_int *cur_col, u_int wrap)
 {
 	return (ahc_print_register(NULL, 0, "SCB_64_BTT",
 	    0xd0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_cchaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCHADDR",
-	    0xe0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_cchcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCHCNT",
-	    0xe8, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccsgram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSGRAM",
-	    0xe9, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccsgaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSGADDR",
-	    0xea, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CCSGCTL_parse_table[] = {
-	{ "CCSGRESET",		0x01, 0x01 },
-	{ "SG_FETCH_NEEDED",	0x02, 0x02 },
-	{ "CCSGEN",		0x08, 0x08 },
-	{ "CCSGDONE",		0x80, 0x80 }
-};
-
-int
-ahc_ccsgctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CCSGCTL_parse_table, 4, "CCSGCTL",
-	    0xeb, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbram_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBRAM",
-	    0xec, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBADDR",
-	    0xed, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t CCSCBCTL_parse_table[] = {
-	{ "CCSCBRESET",		0x01, 0x01 },
-	{ "CCSCBDIR",		0x04, 0x04 },
-	{ "CCSCBEN",		0x08, 0x08 },
-	{ "CCARREN",		0x10, 0x10 },
-	{ "ARRDONE",		0x40, 0x40 },
-	{ "CCSCBDONE",		0x80, 0x80 }
-};
-
-int
-ahc_ccscbctl_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(CCSCBCTL_parse_table, 6, "CCSCBCTL",
-	    0xee, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbcnt_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBCNT",
-	    0xef, regvalue, cur_col, wrap));
-}
-
-int
-ahc_scbbaddr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SCBBADDR",
-	    0xf0, regvalue, cur_col, wrap));
-}
-
-int
-ahc_ccscbptr_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "CCSCBPTR",
-	    0xf1, regvalue, cur_col, wrap));
-}
-
-int
-ahc_hnscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "HNSCB_QOFF",
-	    0xf4, regvalue, cur_col, wrap));
-}
-
-int
-ahc_snscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SNSCB_QOFF",
-	    0xf6, regvalue, cur_col, wrap));
-}
-
-int
-ahc_sdscb_qoff_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(NULL, 0, "SDSCB_QOFF",
-	    0xf8, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t QOFF_CTLSTA_parse_table[] = {
-	{ "SDSCB_ROLLOVER",	0x10, 0x10 },
-	{ "SNSCB_ROLLOVER",	0x20, 0x20 },
-	{ "SCB_AVAIL",		0x40, 0x40 },
-	{ "SCB_QSIZE_256",	0x06, 0x06 },
-	{ "SCB_QSIZE",		0x07, 0x07 }
-};
-
-int
-ahc_qoff_ctlsta_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(QOFF_CTLSTA_parse_table, 5, "QOFF_CTLSTA",
-	    0xfa, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t DFF_THRSH_parse_table[] = {
-	{ "RD_DFTHRSH_MIN",	0x00, 0x00 },
-	{ "WR_DFTHRSH_MIN",	0x00, 0x00 },
-	{ "RD_DFTHRSH_25",	0x01, 0x01 },
-	{ "RD_DFTHRSH_50",	0x02, 0x02 },
-	{ "RD_DFTHRSH_63",	0x03, 0x03 },
-	{ "RD_DFTHRSH_75",	0x04, 0x04 },
-	{ "RD_DFTHRSH_85",	0x05, 0x05 },
-	{ "RD_DFTHRSH_90",	0x06, 0x06 },
-	{ "RD_DFTHRSH",		0x07, 0x07 },
-	{ "RD_DFTHRSH_MAX",	0x07, 0x07 },
-	{ "WR_DFTHRSH_25",	0x10, 0x10 },
-	{ "WR_DFTHRSH_50",	0x20, 0x20 },
-	{ "WR_DFTHRSH_63",	0x30, 0x30 },
-	{ "WR_DFTHRSH_75",	0x40, 0x40 },
-	{ "WR_DFTHRSH_85",	0x50, 0x50 },
-	{ "WR_DFTHRSH_90",	0x60, 0x60 },
-	{ "WR_DFTHRSH",		0x70, 0x70 },
-	{ "WR_DFTHRSH_MAX",	0x70, 0x70 }
-};
-
-int
-ahc_dff_thrsh_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(DFF_THRSH_parse_table, 18, "DFF_THRSH",
-	    0xfb, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SG_CACHE_SHADOW_parse_table[] = {
-	{ "LAST_SEG_DONE",	0x01, 0x01 },
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahc_sg_cache_shadow_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SG_CACHE_SHADOW_parse_table, 3, "SG_CACHE_SHADOW",
-	    0xfc, regvalue, cur_col, wrap));
-}
-
-static ahc_reg_parse_entry_t SG_CACHE_PRE_parse_table[] = {
-	{ "LAST_SEG_DONE",	0x01, 0x01 },
-	{ "LAST_SEG",		0x02, 0x02 },
-	{ "SG_ADDR_MASK",	0xf8, 0xf8 }
-};
-
-int
-ahc_sg_cache_pre_print(u_int regvalue, u_int *cur_col, u_int wrap)
-{
-	return (ahc_print_register(SG_CACHE_PRE_parse_table, 3, "SG_CACHE_PRE",
-	    0xfc, regvalue, cur_col, wrap));
 }
 
--- scsi-misc-2.6-2008_04_15.pT/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	Thu Apr 24 07:47:54 2008
+++ scsi-misc-2.6-2008_04_15.pU/drivers/scsi/aic7xxx/aic7xxx_seq.h_shipped	Fri Apr 25 02:37:17 2008
@@ -4,9 +4,9 @@
  *
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.seq#58 $
  * $Id: //depot/aic7xxx/aic7xxx/aic7xxx.reg#40 $
  */
-static uint8_t seqprog[] = {
+static const uint8_t seqprog[] = {
 	0xb2, 0x00, 0x00, 0x08,
 	0xf7, 0x11, 0x22, 0x08,
 	0x00, 0x65, 0xee, 0x59,
 	0xf7, 0x01, 0x02, 0x08,
@@ -1080,9 +1080,9 @@
 {
 	return (0);
 }
 
-static struct patch {
+static const struct patch {
 	ahc_patch_func_t		*patch_func;
 	uint32_t		 begin		:10,
 				 skip_instr	:10,
 				 skip_patch	:12;
@@ -1290,9 +1290,9 @@
 	{ ahc_patch13_func, 862, 3, 1 },
 	{ ahc_patch4_func, 865, 12, 1 }
 };
 
-static struct cs {
+static const struct cs {
 	uint16_t	begin;
 	uint16_t	end;
 } critical_sections[] = {
 	{ 11, 18 },

--Boundary-00=_KWUEIyeWbNVlcHz--
