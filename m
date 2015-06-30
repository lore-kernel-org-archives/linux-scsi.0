From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 08/20] [SCSI] mpt3sas: Update MPI2 strings to  MPI2.5
Date: Tue, 30 Jun 2015 12:24:54 +0530
Message-ID: <1435647306-36956-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36640 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbbF3G4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:00 -0400
Received: by pdcu2 with SMTP id u2so746604pdc.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:55:59 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Update MPI2 strings to MPI2.5.

Changes in v2:
	Patch version change only.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bf2d7dc..8730160 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3924,7 +3924,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
 	mpi_request.VF_ID = 0; /* TODO */
 	mpi_request.VP_ID = 0;
-	mpi_request.MsgVersion = cpu_to_le16(MPI2_VERSION);
+	mpi_request.MsgVersion = cpu_to_le16(MPI25_VERSION);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
 	if (_base_is_controller_msix_enabled(ioc))
@@ -4793,7 +4793,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
 	ioc->build_sg = &_base_build_sg_ieee;
 	ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
-	ioc->mpi25 = 1;
 	ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index d635612..c0c774f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -826,7 +826,6 @@ struct MPT3SAS_ADAPTER {
 	MPT_BUILD_SG_SCMD build_sg_scmd;
 	MPT_BUILD_SG    build_sg;
 	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge;
-	u8              mpi25;
 	u16             sge_size_ieee;
 
 	/* function ptr for MPI sg elements only */
-- 
2.0.2

