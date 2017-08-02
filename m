From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH 0/3] constify scsi pci_device_id.
Date: Wed,  2 Aug 2017 22:59:02 +0530
Message-ID: <1501694945-18061-1-git-send-email-arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] scsi: mptfusion: constify pci_device_id.
  [PATCH 2/3] scsi: mptfc: constify pci_device_id.
  [PATCH 3/3] scsi: mptsas: constify pci_device_id.

 drivers/message/fusion/mptfc.c  | 2 +-
 drivers/message/fusion/mptsas.c | 2 +-
 drivers/message/fusion/mptspi.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

-- 
2.7.4
