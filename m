From: Chaitra Basappa <chaitra.basappa@broadcom.com>
Subject: RE: [patch 2/2] mpt3sas: clean up indenting a bit
Date: Fri, 13 May 2016 15:08:01 +0530
Message-ID: <f4ac4d5ee7e1b8584f774674f28a9e38@mail.gmail.com>
References: <20160512203844.GC26894@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20160512203844.GC26894@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Dan,
 Below patch doesn't apply smoothly on latest upstream kernel , we are
seeing Hunk failures.

Thanks,
 Chaitra

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
Sent: Friday, May 13, 2016 2:09 AM
To: Sathya Prakash
Cc: Chaitra P B; Suganath Prabu Subramani; James E.J. Bottomley; Martin K.
Petersen; MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
kernel-janitors@vger.kernel.org
Subject: [patch 2/2] mpt3sas: clean up indenting a bit

The indenting is slightly off in parts of this file so I have tidied it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 6bff13e..34d6f996 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -1865,7 +1865,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 			ds = "SSP";
 		} else {
 			qdepth = MPT3SAS_SATA_QUEUE_DEPTH;
-			 if (raid_device->device_info &
+			if (raid_device->device_info &
 			    MPI2_SAS_DEVICE_INFO_SATA_DEVICE)
 				ds = "SATA";
 			else
@@ -3497,21 +3497,21 @@ _scsih_issue_delayed_event_ack(struct
MPT3SAS_ADAPTER *ioc, u16 smid, u16 event,  void
_scsih_issue_delayed_sas_io_unit_ctrl(struct MPT3SAS_ADAPTER *ioc,
 					u16 smid, u16 handle)
-	{
-		Mpi2SasIoUnitControlRequest_t *mpi_request;
-		u32 ioc_state;
-		int i = smid - ioc->internal_smid;
-		unsigned long flags;
+{
+	Mpi2SasIoUnitControlRequest_t *mpi_request;
+	u32 ioc_state;
+	int i = smid - ioc->internal_smid;
+	unsigned long flags;

-		if (ioc->remove_host) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "%s: host has been removed\n",
-			     __func__, ioc->name));
-			return;
-		} else if (ioc->pci_error_recovery) {
-			dewtprintk(ioc, pr_info(MPT3SAS_FMT
-			    "%s: host in pci error recovery\n",
-			    __func__, ioc->name));
+	if (ioc->remove_host) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: host has been removed\n",
+		     __func__, ioc->name));
+		return;
+	} else if (ioc->pci_error_recovery) {
+		dewtprintk(ioc, pr_info(MPT3SAS_FMT
+		    "%s: host in pci error recovery\n",
+		    __func__, ioc->name));
 		return;
 	}
 	ioc_state = mpt3sas_base_get_iocstate(ioc, 1); @@ -5173,7 +5173,7
@@ _scsih_expander_add(struct MPT3SAS_ADAPTER *ioc, u16 handle)
 	}

 	_scsih_expander_node_add(ioc, sas_expander);
-	 return 0;
+	return 0;

  out_fail:

@@ -7774,9 +7774,9 @@ _mpt3sas_fw_work(struct MPT3SAS_ADAPTER *ioc, struct
fw_event_work *fw_event)
 		break;
 	case MPT3SAS_PORT_ENABLE_COMPLETE:
 		ioc->start_scan = 0;
-	if (missing_delay[0] != -1 && missing_delay[1] != -1)
+		if (missing_delay[0] != -1 && missing_delay[1] != -1)
 			mpt3sas_base_update_missing_delay(ioc,
missing_delay[0],
-			    missing_delay[1]);
+
missing_delay[1]);
 		dewtprintk(ioc, pr_info(MPT3SAS_FMT
 			"port enable: complete from worker thread\n",
 			ioc->name));
