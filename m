From: Joao Pinto <Joao.Pinto-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v10 0/6] add support for DWC UFS Controller
Date: Fri,  4 Mar 2016 17:22:13 +0000
Message-ID: <cover.1457111366.git.jpinto@synopsys.com>
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
- Implement a tc-dwc-g210 containing G210 MPHY specific code
- Implement a tc-dwc-g210 glue platform driver
- Implement a tc-dwc-g210 glue pci driver
- Documentation update

Remark: The individual patches are not atomic, depending on other patches of
the set. The patch set was made like this to improve readability.

Joao Pinto (6):
  fixed typo in ufshcd-pltfrm
  added UFS 2.0 capabilities
  added support for DesignWare Controller
  added support for Synopsys G210 Test Chip
  add TC G210 platform driver
  add TC G210 pci driver

 .../devicetree/bindings/ufs/tc-dwc-g210-pltfrm.txt |  26 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   4 +-
 MAINTAINERS                                        |   6 +
 drivers/scsi/ufs/Kconfig                           |  25 ++
 drivers/scsi/ufs/Makefile                          |   4 +
 drivers/scsi/ufs/tc-dwc-g210-pci.c                 | 178 ++++++++++++
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c              | 109 +++++++
 drivers/scsi/ufs/tc-dwc-g210.c                     | 315 +++++++++++++++++++++
 drivers/scsi/ufs/tc-dwc-g210.h                     |  19 ++
 drivers/scsi/ufs/ufshcd-dwc.c                      | 150 ++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h                      |  26 ++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/scsi/ufs/ufshcd.c                          |  29 +-
 drivers/scsi/ufs/ufshcd.h                          |   2 +
 drivers/scsi/ufs/ufshci-dwc.h                      |  42 +++
 drivers/scsi/ufs/ufshci.h                          |   1 +
 drivers/scsi/ufs/unipro.h                          |  39 +++
 17 files changed, 970 insertions(+), 7 deletions(-)
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
