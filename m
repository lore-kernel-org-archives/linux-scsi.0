From: Joe Perches <joe@perches.com>
Subject: [PATCH trivial next 0/9] treewide: Use vsprintf extention %pf
Date: Tue, 28 Feb 2012 10:49:29 -0800
Message-ID: <cover.1330454853.git.joe@perches.com>
Return-path: <linux-parisc-owner@vger.kernel.org>
Sender: linux-parisc-owner@vger.kernel.org
To: linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, microblaze-uclinux@itee.uq.edu.au, linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org, devel@driverdev.osuosl.org
List-Id: linux-scsi@vger.kernel.org

Emit the actual function name when possible

Joe Perches (9):
  sparc: Use vsprintf extention %pf with builtin_return_address
  alpha: Use vsprintf extention %pf with builtin_return_address
  arm: Use vsprintf extention %pf with builtin_return_address
  microblaze: Use vsprintf extention %pf with builtin_return_address
  powerpc: Use vsprintf extention %pf with builtin_return_address
  parisc: Use vsprintf extention %pf with builtin_return_address
  scsi: Use vsprintf extention %pf with builtin_return_address
  staging: ramster: Use vsprintf extention %pf with builtin_return_address
  gadget: Use vsprintf extention %pf with builtin_return_address

 arch/alpha/kernel/pci_iommu.c               |   20 ++++++++++----------
 arch/arm/nwfpe/fpmodule.c                   |    2 +-
 arch/microblaze/mm/pgtable.c                |    2 +-
 arch/powerpc/mm/pgtable_32.c                |    2 +-
 arch/sparc/kernel/ds.c                      |    2 +-
 arch/sparc/mm/srmmu.c                       |    2 +-
 drivers/parisc/superio.c                    |    2 +-
 drivers/scsi/esp_scsi.c                     |    2 +-
 drivers/staging/ramster/cluster/heartbeat.c |    4 ++--
 drivers/usb/gadget/u_serial.c               |    2 +-
 10 files changed, 20 insertions(+), 20 deletions(-)

-- 
1.7.8.111.gad25c.dirty

