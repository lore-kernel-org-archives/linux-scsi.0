From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v7 0/8] mpt3sas: some bug fixes patches
Date: Wed, 31 Oct 2018 18:53:31 +0530
Message-ID: <1540992219-20291-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

V7 Change Set:
Split some patches into multiple small patches
as suggested by Bjorn Helgaas

v6 Change Set:
Incorporated changes as suggested by Andy.
In Patch 1 converted while loop to do while in
function mpt3sas_wait_for_ioc_to_operational().
And in patch 3 removed parentheses.

V5 Change Set:
V5 post has only defect fixes.
We are reworking and incorporating the suggestions from Bjorn.
And after covering tests, we ll be post Hot-Plug Surprise
 removal patches.

V4 Change Set:
Reframe split strings in print statement, to avoid

V3 Change Set:
Simplified function "mpt3sas_base_pci_device_is_available" and
made inline

V2 Change Set:
Replaced mpt3sas_base_pci_device_is_unplugged with
pci_device_is_present.

V1 Chnage Set:
In Patch 0001 - unlock mutex, if active reset is in progress.

Suganath Prabu (8):
  mpt3sas: Added new #define variable IOC_OPERATIONAL_WAIT_COUNT
  mpt3sas: Separate out mpt3sas_wait_for_ioc
  mpt3sas: Refactor mpt3sas_wait_for_ioc function
  mpt3sas: Call sas_remove_host before removing the target devices
  mpt3sas: Fix Sync cache command failure during driver unload
  mpt3sas: Don't modify EEDPTagMode field setting on SAS3.5 HBA devices
  mpt3sas: Fix driver modifying persistent data in Manufacturing page11
  mpt3sas: Bump driver version to 27.100.00.00.

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 73 +++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  8 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 27 ++--------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 38 ++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 91 ++++++--------------------------
 6 files changed, 106 insertions(+), 152 deletions(-)

-- 
1.8.3.1
