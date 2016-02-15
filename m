From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v8 0/3] add support for DWC UFS Controller
Date: Mon, 15 Feb 2016 15:25:10 +0000
Message-ID: <cover.1455549221.git.jpinto@synopsys.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, julian.calaby-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, CARLOS.PALMINHA-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The work consisted of:
- Fixed typo in ufshcd-pltfrm.c
- Tweak ufshcd.c for UFS 2.0 support
- Implement ufshcd-dwc which contains all DWC HW specific code
- Unipro attributes were added and new registers were added to the driver
- Implement a ufs-dwc glue platform driver
- Implement a ufs-dwc-pci glue pci driver
- Documentation update

Joao Pinto (3):
  fixed typo in ufshcd-pltfrm
  added UFS 2.0 capabilities
  add support for DWC UFS Host Controller

 Documentation/devicetree/bindings/ufs/ufs-dwc.txt  |  19 +
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   4 +-
 MAINTAINERS                                        |   6 +
 drivers/scsi/ufs/Kconfig                           |  51 +++
 drivers/scsi/ufs/Makefile                          |   3 +
 drivers/scsi/ufs/ufs-dwc-pci.c                     | 172 ++++++++
 drivers/scsi/ufs/ufs-dwc.c                         |  96 +++++
 drivers/scsi/ufs/ufshcd-dwc.c                      | 431 +++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                      |  18 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  29 +-
 drivers/scsi/ufs/ufshci-dwc.h                      |  42 ++
 drivers/scsi/ufs/ufshci.h                          |   1 +
 drivers/scsi/ufs/unipro.h                          |  39 ++
 14 files changed, 906 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-dwc.txt
 create mode 100644 drivers/scsi/ufs/ufs-dwc-pci.c
 create mode 100644 drivers/scsi/ufs/ufs-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

-- 
1.8.1.5

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
