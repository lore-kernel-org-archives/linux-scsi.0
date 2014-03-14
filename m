From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: [PATCH][SCSI]mpt2sas: Description Patch
Date: Fri, 14 Mar 2014 21:03:12 +0530
Message-ID: <20140314153312.GA7904@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org


Please consider this patch set for next kernel release.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

[PATCH 01/11][SCSI]mpt2sas: Added driver module parameter max_msix_vectors.
[PATCH 02/11][SCSI]mpt2sas: Added new driver module Parameter disable_eedp to Disable EEDP Support.
[PATCH 03/11][SCSI]mpt2sas: MPI2 Rev Y (2.00.17) and Rev Z (2.00.18) specifications.
[PATCH 04/11][SCSI]mpt2sas: Copyright in driver sources is updated for year the 2014.
[PATCH 05/11][SCSI]mpt2sas: Clear PFA Status on SGPIO when PFA Drive is Removed or Replaced.
[PATCH 06/11][SCSI]mpt2sas: Bump mpt2sas driver version to 17.100.00.00.
[PATCH 07/11][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive.
[PATCH 08/11][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support.
[PATCH 09/11][SCSI]mpt2sas: Get IOC_FACTS information using handshake protocol only after HBA card gets into READY or Operational state.
[PATCH 10/11][SCSI]mpt2sas: Added module parameter 'unblock_io' to unblock IO's during disk addition.
[PATCH 11/11][SCSI]mpt2sas: Bump mpt2sas driver version to 18.100.00.00.
