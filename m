From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH 00/11] Updates for scsi-next
Date: Thu,  1 Dec 2016 14:10:34 -0500
Message-ID: <1480619445-45073-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com
List-Id: linux-scsi@vger.kernel.org

From: root <sasikumar.pc@broadcom.com>


Sasikumar Chandrasekaran (11):
  megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: 128 MSIX Support
  megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and
    IO Coalescing
  megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID
    1/10 Writes
  megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: Add the Support for SAS3.5 Generic Megaraid Controllers
    Capabilities
  megaraid_sas: Enable or Disable Fast path based on the PCI Threshold
    Bandwidth
  megaraid_sas: ldio_outstanding variable is not decremented in
    completion path
  megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        | 139 ++++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 242 +++++++---
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 319 +++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 687 ++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 318 ++++++++++++-
 5 files changed, 1474 insertions(+), 231 deletions(-)

-- 
1.8.3.1
