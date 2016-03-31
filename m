From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 0/9] add support for DWC UFS Controller
Date: Thu, 31 Mar 2016 19:57:13 +0100
Message-ID: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

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
  fixed typo in ufshcd-pltfrm
  add UFS 2.0 to ufshcd-pltfrm bindings
  added UFS 2.0 capabilities
  added unipro attributes
  added link status to ufshci
  added support for DesignWare Controller
  added support for Synopsys G210 Test Chip
  add TC G210 platform driver
  add TC G210 pci driver

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   4 +-
 MAINTAINERS                                        |   6 +
 drivers/scsi/ufs/Kconfig                           |  25 ++
 drivers/scsi/ufs/Makefile                          |   4 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 | 181 ++++++++++++
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 113 ++++++++
 drivers/scsi/ufs/tc-dwc-g210.c                     | 315 +++++++++++++++++++++
 drivers/scsi/ufs/tc-dwc-g210.h                     |  19 ++
 drivers/scsi/ufs/ufshcd-dwc.c                      | 150 ++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                      |  26 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  90 +++---
 drivers/scsi/ufs/ufshcd.h                          |   7 +
 drivers/scsi/ufs/ufshci-dwc.h                      |  36 +++
 drivers/scsi/ufs/ufshci.h                          |  11 +
 drivers/scsi/ufs/unipro.h                          |  39 +++
 17 files changed, 1010 insertions(+), 44 deletions(-)
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
