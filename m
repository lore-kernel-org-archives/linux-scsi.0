From: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v6 0/4] mpt3sas: Hot-Plug Surprise removal support on IOC.
Date: Tue, 23 Oct 2018 15:51:17 +0530
Message-ID: <1540290081-15827-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: helgaas@kernel.org, lukas@wunner.de, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, ruscur@russell.cc, sbobroff@linux.ibm.com, oohall@gmail.com, andy.shevchenko@gmail.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

v6 Change set:
Incorporated changes as suggested by Andy.
In Patch 1 converted while loop to do while in
function mpt3sas_wait_for_ioc_to_operational().
And in patch 3 removed parentheses.

V5 Change set:
V5 post has only defect fixes.
We are reworking and incorporating the suggestions from Bjorn.
And after covering tests, we ll be post Hot-Plug Surprise
 removal patches.

V4 Change set:
Reframe split strings in print statement, to avoid

V3 Change Set:
Simplified function "mpt3sas_base_pci_device_is_available" and
made inline

V2 changes:
Replaced mpt3sas_base_pci_device_is_unplugged with
pci_device_is_present.

V1 changes:
In Patch 0001 - unlock mutex, if active reset is in progress.
Suganath Prabu (4):
  mpt3sas: Separate out mpt3sas_wait_for_ioc_to_operational
  mpt3sas: Fix Sync cache command failure during driver unload
  mpt3sas:Fix driver modifying persistent data.
  mpt3sas: Bump driver version to 27.100.00.00.

 drivers/scsi/mpt3sas/mpt3sas_base.c      | 75 ++++++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  8 +++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 28 +++---------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 21 ++-------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 38 +++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 70 ++++++-----------------------
 6 files changed, 106 insertions(+), 134 deletions(-)

-- 
1.8.3.1
