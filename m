From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 18/22] [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
Date: Thu, 20 Nov 2014 12:35:51 +0530
Message-ID: <1416467155-16869-19-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:40799 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757136AbaKTHOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:14:48 -0500
Received: by mail-pa0-f48.google.com with SMTP id rd3so1999211pab.7
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:14:48 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Update MPI2 strings to MPI2.5.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 drivers/scsi/mpt3sas/mpt3sas_base.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4322d7c..5fafd51 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3891,7 +3891,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	mpi_request.WhoInit = MPI2_WHOINIT_HOST_DRIVER;
 	mpi_request.VF_ID = 0; /* TODO */
 	mpi_request.VP_ID = 0;
-	mpi_request.MsgVersion = cpu_to_le16(MPI2_VERSION);
+	mpi_request.MsgVersion = cpu_to_le16(MPI25_VERSION);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
 	if (_base_is_controller_msix_enabled(ioc))
@@ -4759,7 +4759,6 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
 	ioc->build_sg = &_base_build_sg_ieee;
 	ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
-	ioc->mpi25 = 1;
 	ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
 
 	/*
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 4c07f17..c27e94e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -818,7 +818,6 @@ struct MPT3SAS_ADAPTER {
 	MPT_BUILD_SG_SCMD build_sg_scmd;
 	MPT_BUILD_SG    build_sg;
 	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge;
-	u8              mpi25;
 	u16             sge_size_ieee;
 
 	/* function ptr for MPI sg elements only */
-- 
2.0.2

