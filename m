From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH 0/3] add support for DWC UFS Controller
Date: Wed,  3 Feb 2016 11:28:23 +0000
Message-ID: <cover.1454498292.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.sy@samsung.com, h.vinayak@samsung.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

The work consisted of:
- Tweak ufshcd.c for UFS 2.0 support
- Implement ufshcd-dwc which contains all DWC HW specific code
- Implement a ufs-dwc glue platform driver

Joao Pinto (3):
  fixed typo
  added support for ufs 2.0
  add support for DWC UFS Host Controller

 Documentation/devicetree/bindings/ufs/ufs-dwc.txt |  16 +
 MAINTAINERS                                       |   6 +
 drivers/scsi/ufs/Kconfig                          |  45 ++
 drivers/scsi/ufs/Makefile                         |   2 +
 drivers/scsi/ufs/ufs-dwc.c                        |  96 +++
 drivers/scsi/ufs/ufshcd-dwc.c                     | 768 ++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                     |  26 +
 drivers/scsi/ufs/ufshcd-pci.c                     |  20 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                  |   2 +-
 drivers/scsi/ufs/ufshcd.c                         |  61 +-
 drivers/scsi/ufs/ufshcd.h                         |  22 +
 drivers/scsi/ufs/ufshci-dwc.h                     |  42 ++
 drivers/scsi/ufs/ufshci.h                         |   1 +
 drivers/scsi/ufs/unipro.h                         |  39 ++
 14 files changed, 1127 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

-- 
1.8.1.5
