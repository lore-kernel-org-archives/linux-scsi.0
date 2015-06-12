From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 08/20] [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
Date: Fri, 12 Jun 2015 15:12:20 +0530
Message-ID: <1434102153-38581-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33101 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbbFLJna (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2015 05:43:30 -0400
Received: by qkhg32 with SMTP id g32so14880010qkh.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2015 02:43:29 -0700 (PDT)
In-Reply-To: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Update MPI2 strings to MPI2.5.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 32b86bf..6739c0a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3901,7 +3901,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
 	mpi_request.VF_ID = 0; /* TODO */
 	mpi_request.VP_ID = 0;
-	mpi_request.MsgVersion = cpu_to_le16(MPI2_VERSION);
+	mpi_request.MsgVersion = cpu_to_le16(MPI25_VERSION);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
 	if (_base_is_controller_msix_enabled(ioc))
@@ -4769,7 +4769,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
 	ioc->build_sg = &_base_build_sg_ieee;
 	ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
-	ioc->mpi25 = 1;
 	ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 9396a76..2318ef8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -819,7 +819,6 @@ struct MPT3SAS_ADAPTER {
 	MPT_BUILD_SG_SCMD build_sg_scmd;
 	MPT_BUILD_SG    build_sg;
 	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge;
-	u8              mpi25;
 	u16             sge_size_ieee;
 
 	/* function ptr for MPI sg elements only */
-- 
2.0.2

