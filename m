From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
Subject: [PATCH][SCSI]mpt2sas: Description Patch
Date: Wed, 25 Jun 2014 15:59:37 +0530
Message-ID: <20140625102937.GA12856@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, sreekanth.reddy@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

Just resending below set of patches which I have sent on 14th March 2014.
And I have removed below subjected patch since we have already have the
module parameter port_mask to disable EEDP support.
[PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.

Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---

[RESEND][PATCH 01/10][SCSI]mpt2sas: Added driver module parameter max_msix_vectors.
[RESEND][PATCH 02/10][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications.
[RESEND][PATCH 03/10][SCSI]mpt2sas: Copyright in driver sources is updated for year the 2014.
[RESEND][PATCH 04/10][SCSI]mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[RESEND][PATCH 05/10][SCSI]mpt2sas: Bump mpt2sas driver version to 17.100.00.00.
[RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive.
[RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[RESEND][PATCH 08/10][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
[RESEND][PATCH 09/10][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition.
[RESEND][PATCH 10/10][SCSI]mpt2sas: Bump mpt2sas driver version to 18.100.00.00.
