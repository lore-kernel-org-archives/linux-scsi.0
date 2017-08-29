From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v3 0/5] scsi: ufs: add ufs driver code for Hisilicon Hi3660 SoC
Date: Tue, 29 Aug 2017 16:41:11 +0800
Message-ID: <20170829084116.106695-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: guodong.xu@linaro.org, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

This patchset adds driver support for UFS for Hi3660 SoC. It is verified on HiKey960 board

Li Wei (5):
  scsi: ufs: add Hisilicon ufs driver code
  dt-bindings: scsi: ufs: add document for hisi-ufs
  arm64: dts: add ufs dts node
  arm64: defconfig: enable configs for Hisilicon ufs
  arm64: defconfig: enable f2fs and squashfs

 Documentation/devicetree/bindings/ufs/ufs-hisi.txt |  35 ++
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |  16 +
 arch/arm64/configs/defconfig                       |  11 +
 drivers/scsi/ufs/Kconfig                           |   9 +
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/ufs-hisi.c                        | 634 +++++++++++++++++++++
 drivers/scsi/ufs/ufs-hisi.h                        | 163 ++++++
 7 files changed, 869 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
 create mode 100644 drivers/scsi/ufs/ufs-hisi.c
 create mode 100644 drivers/scsi/ufs/ufs-hisi.h

-- 
2.11.0
