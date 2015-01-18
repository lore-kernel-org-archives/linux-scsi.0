From: Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 0/2] Added pci_mapping_error() call and related clean up
Date: Sun, 18 Jan 2015 12:11:01 +0530
Message-ID: <cover.1421489699.git.tinajohnson.1234@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, julia.lawall@lip6.fr, abhijit.mahajan@avagotech.com, nagalakshmi.nandigama@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tina Johnson <tinajohnson.1234@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Replaced null test on dma handle with pci_dma_mapping_error() and cleaned 
up the error handling code.

Tina Johnson (2):
  drivers: scsi: mpt2sas: Added pci_dma_mapping_error() call
  drivers: scsi: mpt2sas: Clean up error handling for calls to pci_map_single

 drivers/scsi/mpt2sas/mpt2sas_transport.c |   35 +++++++++++++++---------------
 1 file changed, 17 insertions(+), 18 deletions(-)

-- 
1.7.10.4
