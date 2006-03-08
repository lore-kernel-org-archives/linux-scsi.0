From: akpm@osdl.org
Subject: [patch 27/28] drivers/message/fusion/mptbase.c: make mpt_read_ioc_pg_3() static
Date: Wed, 08 Mar 2006 00:14:43 -0800
Message-ID: <200603080816.k288GWtC002260@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:24493 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932513AbWCHITu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:19:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, Eric.Moore@lsil.com


From: Adrian Bunk <bunk@stusta.de>

mpt_read_ioc_pg_3() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/fusion/mptbase.c |    4 ++--
 drivers/message/fusion/mptbase.h |    1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-make-mpt_read_ioc_pg_3-static drivers/message/fusion/mptbase.c
--- devel/drivers/message/fusion/mptbase.c~drivers-message-fusion-mptbasec-make-mpt_read_ioc_pg_3-static	2006-03-08 00:13:08.000000000 -0800
+++ devel-akpm/drivers/message/fusion/mptbase.c	2006-03-08 00:13:08.000000000 -0800
@@ -180,6 +180,7 @@ static void	mpt_sp_ioc_info(MPT_ADAPTER 
 static void	mpt_fc_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_spi_log_info(MPT_ADAPTER *ioc, u32 log_info);
 static void	mpt_sas_log_info(MPT_ADAPTER *ioc, u32 log_info);
+static int	mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 
 /* module entry point */
 static int  __init    fusion_init  (void);
@@ -4871,7 +4872,7 @@ done_and_free:
 	return rc;
 }
 
-int
+static int
 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc)
 {
 	IOCPage3_t		*pIoc3;
@@ -6364,7 +6365,6 @@ EXPORT_SYMBOL(mpt_stm_index);
 EXPORT_SYMBOL(mpt_HardResetHandler);
 EXPORT_SYMBOL(mpt_config);
 EXPORT_SYMBOL(mpt_findImVolumes);
-EXPORT_SYMBOL(mpt_read_ioc_pg_3);
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
diff -puN drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-make-mpt_read_ioc_pg_3-static drivers/message/fusion/mptbase.h
--- devel/drivers/message/fusion/mptbase.h~drivers-message-fusion-mptbasec-make-mpt_read_ioc_pg_3-static	2006-03-08 00:13:08.000000000 -0800
+++ devel-akpm/drivers/message/fusion/mptbase.h	2006-03-08 00:13:08.000000000 -0800
@@ -1021,7 +1021,6 @@ extern int	 mpt_config(MPT_ADAPTER *ioc,
 extern void	 mpt_alloc_fw_memory(MPT_ADAPTER *ioc, int size);
 extern void	 mpt_free_fw_memory(MPT_ADAPTER *ioc);
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
-extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
 extern int	 mptbase_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum);
 
_
