From: Li Wei <liwei213@huawei.com>
Subject: [PATCH v11 0/4] [RESEND] scsi: ufs: add ufs driver code for Hisilicon Hi3660 SoC
Date: Tue, 17 Jul 2018 17:36:55 +0800
Message-ID: <20180717093659.103263-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, sunzhaosheng@hisilicon.com, ian.rickards@arm.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, john.stultz@linaro.org, liwei213@huawei.com, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

This patchset adds driver support for UFS for Hi3660 SoC. It is verified on HiKey960 board.

Li Wei (4):
  scsi: ufs: add Hisilicon ufs driver code
  dt-bindings: scsi: ufs: add document for hisi-ufs
  arm64: dts: add ufs dts node
  arm64: defconfig: enable configs for Hisilicon ufs

 Documentation/devicetree/bindings/ufs/ufs-hisi.txt |  41 ++
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  10 +-
 arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |  18 +
 arch/arm64/configs/defconfig                       |   1 +
 drivers/scsi/ufs/Kconfig                           |   9 +
 drivers/scsi/ufs/Makefile                          |   1 +
 drivers/scsi/ufs/ufs-hisi.c                        | 619 +++++++++++++++++++++
 drivers/scsi/ufs/ufs-hisi.h                        | 115 ++++
 8 files changed, 811 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
 create mode 100644 drivers/scsi/ufs/ufs-hisi.c
 create mode 100644 drivers/scsi/ufs/ufs-hisi.h

Major changes in v11:
 - solve review comments from John Stultz.
  *include Rob Herring's Reviewed-by tag to the dt-binding patch.
  *drop the defconfig changes, such as f2fs and squashfs related.
Major changes in v10:
 - solve review comments from Rob Herring.
   *Modify the "reset-names" describe in ufs-hisi.txt binding file.
   *List clocks in ufs-hisi.txt binding file.
   *remove the "arst" and keep only "rst" in the binging files.
   *remove the "arst" member from both dts and c code. 
Major changes in v9:
 - solve review comments from Rob Herring.
   *remove freq-table-hz in ufs-hisi.txt binding file.
   *Move the rst to the ufshcd_pltfm.txt common binding file.
   *Modify the member "assert" of UFS host structure to "arst".
Major changes in v8:
 - solve review comments from zhangfei.
   *Add Version history.
 - solve review comments from Rob Herring.
   *remove freq-table-hz.
 -  solve review comments from Riku Voipio.
   *Add MODULE_DEVICE_TABLE for ufs driver.
-- 
Major changes in v7:
 - solve review comments from Philippe Ombredanne.
   *use the new SPDX license ids instead of the GNU General Public License.
-- 
2.15.0
