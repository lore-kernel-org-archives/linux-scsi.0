From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 0/2] PHY: Add SATA Gen1/Gen2 support to the APM X-Gene SoC 15Gbps PHY driver
Date: Fri, 18 Apr 2014 23:33:15 +0530
Message-ID: <1397844197-13356-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: kishon@ti.com, tj@kernel.org
Cc: olof@lixom.net, arnd@arndb.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds the necessary code to support SATA Gen1/Gen2 for the APM X-Gene
SoC 15Gbps Multi-purpose PHY driver.

Suman Tripathi (2):
  PHY: Add function set_rate to generic PHY framework
  PHY: Add Gen1/Gen2 support for the APM SoC X-Gene SATA PHY driver

 drivers/phy/phy-core.c  | 29 ++++++++++++++++++++++
 drivers/phy/phy-xgene.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy/phy.h |  8 +++++++
 3 files changed, 101 insertions(+)

--
1.8.2.1

