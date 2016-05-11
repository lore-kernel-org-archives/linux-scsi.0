From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 0/9] add support for DWC UFS Controller
Date: Wed, 11 May 2016 12:21:24 +0100
Message-ID: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:36280 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbcEKLVk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

As requested, I am sending v15 to be included in the SCSI patchwork.
The patches were produced on top of the latest (2016-05-02) 4.7/scsi-queue
branch. The patches were also validated by checkpatch.pl.

The work consisted of:
- Fixed typo in ufshcd-pltfrm.c
- Tweak ufshcd.c for UFS 2.0 support
- Implement ufshcd-dwc which contains all DWC HW specific code
- Unipro attributes were added and new registers were added to the driver
- Implement a tc-dwc-g210 containing G210 MPHY specific code
- Implement a tc-dwc-g210 glue platform driver
- Implement a tc-dwc-g210 glue pci driver
- Documentation update

Joao Pinto (9):
  ufs: fixed typo in ufshcd-pltfrm
  ufs: add UFS 2.0 to ufshcd-pltfrm bindings
  ufs: add UFS 2.0 capabilities
  ufs: add unipro attributes
  ufs: add link status to ufshci
  ufs: add support for DesignWare Controller
  ufs: add support for Synopsys G210 Test Chip
  ufs: add TC G210 platform driver
  ufs: add TC G210 pci driver

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   4 +-
 MAINTAINERS                                        |   6 +
 drivers/scsi/ufs/Kconfig                           |  16 ++
 drivers/scsi/ufs/Makefile                          |   2 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 | 181 ++++++++++++
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 ++++++++
 drivers/scsi/ufs/tc-dwc-g210.c                     | 315 +++++++++++++++++++++
 drivers/scsi/ufs/tc-dwc-g210.h                     |  19 ++
 drivers/scsi/ufs/ufshcd-dwc.c                      | 150 ++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                      |  26 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  89 +++---
 drivers/scsi/ufs/ufshcd.h                          |   7 +
 drivers/scsi/ufs/ufshci-dwc.h                      |  36 +++
 drivers/scsi/ufs/ufshci.h                          |  11 +
 drivers/scsi/ufs/unipro.h                          |  39 +++
 17 files changed, 998 insertions(+), 44 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pci.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210.c
 create mode 100644 drivers/scsi/ufs/tc-dwc-g210.h
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

-- 
1.8.1.5

