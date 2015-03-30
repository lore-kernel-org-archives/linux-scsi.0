From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 08/20] [SCSI] mpt3sas: Update MPI2 strings to MPI2.5
Date: Mon, 30 Mar 2015 19:25:11 +0530
Message-ID: <1427723723-12676-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

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
index 29ecfd1..175499c 100644
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
