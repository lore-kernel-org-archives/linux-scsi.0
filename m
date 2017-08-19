From: Bhumika Goyal <bhumirks@gmail.com>
Subject: [PATCH 00/15] drivers: make device_type const
Date: Sat, 19 Aug 2017 13:52:11 +0530
Message-ID: <1503130946-2854-1-git-send-email-bhumirks__28383.2054505639$1503130986$gmane$org@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34266 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751101AbdHSIWv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Aug 2017 04:22:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: julia.lawall@lip6.fr, bp@alien8.de, mchehab@kernel.org, daniel.vetter@intel.com, jani.nikula@linux.intel.com, seanpaul@chromium.org, airlied@linux.ie, g.liakhovetski@gmx.de, tomas.winkler@intel.com, dwmw2@infradead.org, computersforpeace@gmail.com, boris.brezillon@free-electrons.com, marek.vasut@gmail.com, richard@nod.at, cyrille.pitchen@wedev4u.fr, peda@axentia.se, kishon@ti.com, bhelgaas@google.com, thierry.reding@gmail.com, jonathanh@nvidia.com, dvhart@infradead.org, andy@infradead.org, ohad@wizery.com, bjorn.andersson@linaro.org, freude@de.ibm.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com, johan@kernel.org, elder@kernel.org, gregkh@linuxfoundation.orgheik
Cc: Bhumika Goyal <bhumirks@gmail.com>

Make device_type const. Done using Coccinelle.

Bhumika Goyal (15):
  EDAC: make device_type const
  drm: make device_type const
  [media] i2c: make device_type const
  [media] rc: make device_type const
  mei: make device_type const
  mtd:  make device_type const
  mux: make device_type const
  PCI: make device_type const
  phy: tegra: make device_type const
  platform/x86: wmi: make device_type const
  remoteproc: make device_type const
  s390/zcrypt: make device_type const
  scsi: make device_type const
  staging: greybus: make device_type const
  usb: make device_type const

 drivers/edac/edac_mc_sysfs.c           | 8 ++++----
 drivers/edac/i7core_edac.c             | 4 ++--
 drivers/gpu/drm/drm_sysfs.c            | 2 +-
 drivers/gpu/drm/ttm/ttm_module.c       | 2 +-
 drivers/media/i2c/soc_camera/mt9t031.c | 2 +-
 drivers/media/rc/rc-main.c             | 2 +-
 drivers/misc/mei/bus.c                 | 2 +-
 drivers/mtd/mtdcore.c                  | 2 +-
 drivers/mux/mux-core.c                 | 2 +-
 drivers/pci/endpoint/pci-epf-core.c    | 4 ++--
 drivers/phy/tegra/xusb.c               | 4 ++--
 drivers/platform/x86/wmi.c             | 6 +++---
 drivers/remoteproc/remoteproc_core.c   | 2 +-
 drivers/s390/crypto/ap_card.c          | 2 +-
 drivers/s390/crypto/ap_queue.c         | 2 +-
 drivers/scsi/fcoe/fcoe_sysfs.c         | 4 ++--
 drivers/scsi/scsi_transport_iscsi.c    | 4 ++--
 drivers/staging/greybus/gbphy.c        | 2 +-
 drivers/usb/common/ulpi.c              | 2 +-
 19 files changed, 29 insertions(+), 29 deletions(-)

-- 
1.9.1
