From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 0/4] ata: Add APM X-Gene SoC 6.0Gbps SATA PHY support
Date: Tue, 19 Nov 2013 16:53:13 -0700
Message-ID: <1384905197-3566-1-git-send-email-lho@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

ata: Add APM X-Gene SoC 6.0Gbps SATA PHY support

This patch adds support for APM X-Gene SoC 6.0Gbps SATA PHY. This is the
physical layer interface for the corresponding SATA host controller. This
driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
In addition, the new PHY generic framework is patched to provide an
function to set the speed of the PHY.

v2
* Remove port knowledge from functions
* Make all functions static
* Remove ID completely
* Make resource requirement based on compatible type
* Rename override PHY parameters with more descriptive name
* Add override PHY parameter for per controller, per port, and per speed
* Patch the generic PHY frame to expose set_speed operation

v1
* Initial version

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Loc Ho (4):
  PHY: Add function set_speed to generic PHY framework
  Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding
    documentation
  ata: add APM X-Gene SoC 6.0Gbps SATA PHY driver
  arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries

 .../devicetree/bindings/ata/apm-xgene-phy.txt      |   61 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   28 +
 drivers/ata/Kconfig                                |    6 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/sata_xgene_phy.c                       | 2067 ++++++++++++++++++++
 include/linux/phy/phy.h                            |   22 +
 6 files changed, 2185 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
 create mode 100644 drivers/ata/sata_xgene_phy.c

