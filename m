From: Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/2] scsi: ufs: Add PCI driver for Intel Host controllers
Date: Mon,  5 Jun 2017 11:36:53 +0300
Message-ID: <1496651815-13416-1-git-send-email-adrian.hunter@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>, Michal Potomski <michalx.potomski@intel.com>, Grzegorz Janca <grzegorz.janca@intel.com>
List-Id: linux-scsi@vger.kernel.org

Hi


Here is a PCI driver for Intel UFS host controllers, with a small tidy-up
precursor patch.


Szymon Mielczarek (2):
      scsi: ufs: Tidy clocks list head usage
      scsi: ufshcd-intel-pci: Add PCI driver for Intel Host controllers

 drivers/scsi/ufs/Kconfig            |  11 +++
 drivers/scsi/ufs/Makefile           |   1 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c  |   2 -
 drivers/scsi/ufs/ufshcd-intel-pci.c | 183 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pci.c       |   2 -
 drivers/scsi/ufs/ufshcd-pltfrm.c    |   2 -
 drivers/scsi/ufs/ufshcd.c           |  12 ++-
 7 files changed, 202 insertions(+), 11 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-intel-pci.c


Regards
Adrian
