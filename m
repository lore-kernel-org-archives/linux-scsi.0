From: Loc Ho <lho@apm.com>
Subject: [PATCH v3 0/4] PHY: Add APM X-Gene SoC 15Gbps Multi-purpose PHY support
Date: Mon, 25 Nov 2013 22:46:54 -0700
Message-ID: <1385444818-29682-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:59153 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751813Ab3KZFrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2013 00:47:07 -0500
Received: by mail-pd0-f174.google.com with SMTP id y13so6990027pdi.5
        for <linux-scsi@vger.kernel.org>; Mon, 25 Nov 2013 21:47:06 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

PHY: Add APM X-Gene SoC 15Gbps Multi-purpose PHY support

This patch adds support for APM X-Gene SoC 15Gbps Multi-purpose PHY. This
is the physical layer interface for the corresponding host controller. This
driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.
In addition, the new PHY generic framework is patched to provide an
function to set the speed of the PHY.

v3
* Major re-write of the code based on various review comments
* Support external clock only at the moment
* Support SATA mode only at the moment
* No UEFI support at the moment

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
  Documentation: Add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
    binding documentation
  PHY: add APM X-Gene SoC 15Gbps Multi-purpose PHY driver
  arm64: Add APM X-Gene SoC 15Gbps Multi-purpose PHY DTS entries

 .../devicetree/bindings/ata/apm-xgene-phy.txt      |   89 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   31 +
 drivers/phy/Kconfig                                |    6 +
 drivers/phy/Makefile                               |    2 +
 drivers/phy/phy-core.c                             |   21 +
 drivers/phy/phy-xgene.c                            | 1838 ++++++++++++++++++++
 include/linux/phy/phy.h                            |    8 +
 7 files changed, 1995 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
 create mode 100644 drivers/phy/phy-xgene.c

