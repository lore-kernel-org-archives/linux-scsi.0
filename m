From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v5 0/2] add support for DWC UFS Controller
Date: Wed, 10 Feb 2016 15:12:35 +0000
Message-ID: <cover.1455116488.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com, arnd@arndb.de, JBottomley@odin.com, martin.petersen@oracle.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

The work consisted of:
- Fixed typo in ufshcd-pltfrm.c
- Tweak ufshcd.c for UFS 2.0 support
- Implement ufshcd-dwc which contains all DWC HW specific code
- Unipro attributes were added and new registers were added to the driver
- Implement a ufs-dwc glue platform driver
- Implement a ufs-dwc-pci glue pci driver

Joao Pinto (2):
  fixed typo in ufshcd-pltfrm
  add support for DWC UFS Host Controller

 Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  17 +
 MAINTAINERS                                       |   6 +
 drivers/scsi/ufs/Kconfig                          |  41 ++
 drivers/scsi/ufs/Makefile                         |   3 +
 drivers/scsi/ufs/ufs-dwc-pci.c                    | 180 ++++++
 drivers/scsi/ufs/ufs-dwc.c                        | 102 +++
 drivers/scsi/ufs/ufshcd-dwc.c                     | 736 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                     |  18 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                  |   2 +-
 drivers/scsi/ufs/ufshcd.c                         |  50 +-
 drivers/scsi/ufs/ufshcd.h                         |  13 +
 drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
 drivers/scsi/ufs/ufshci.h                         |   1 +
 drivers/scsi/ufs/unipro.h                         |  39 ++
 14 files changed, 1232 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

-- 
1.8.1.5
