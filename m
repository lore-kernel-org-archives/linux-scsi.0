From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH v2 0/3] Add UFS controller support for HI3670 SoC
Date: Sat,  5 Jan 2019 12:58:56 +0530
Message-ID: <20190105072859.9134-1-manivannan.sadhasivam@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, liwei213@huawei.com, robh+dt@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org, john.stultz@linaro.org, amit.kucheria@linaro.org, guodong.xu@linaro.org, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

This patchset adds UFS controller support for HiSilicon HI3670 SoC.
HI3760 SoC is very similar to HI3660 SoC with almost same IPs, hence
the same driver is extended to provide UFS support. Only major difference
is the PHY. HI3670 has 10nm PHY, hence that parameter is used to
distinguish the difference between two in driver.

Thanks,
Mani

Changes in v2:

As per Rob's review:

* Removed interrupt-parent property from binding.
* Fixed the bindings patch commit message.

Manivannan Sadhasivam (3):
  dt-bindings: ufs: Add HI3670 UFS controller binding
  arm64: dts: hisilicon: hi3670: Add UFS controller support
  scsi: ufs: Add HI3670 SoC UFS driver support

 .../devicetree/bindings/ufs/ufs-hisi.txt      |   5 +-
 arch/arm64/boot/dts/hisilicon/hi3670.dtsi     |  18 +++
 drivers/scsi/ufs/ufs-hisi.c                   | 127 +++++++++++++++---
 drivers/scsi/ufs/ufs-hisi.h                   |   4 +
 4 files changed, 130 insertions(+), 24 deletions(-)

-- 
2.17.1
