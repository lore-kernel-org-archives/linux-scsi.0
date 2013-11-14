From: Loc Ho <lho@apm.com>
Subject: [PATCH 0/3] ata: Add APM X-Gene SoC 6.0Gbps SATA PHY support
Date: Thu, 14 Nov 2013 12:31:56 -0700
Message-ID: <1384457519-21335-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:35734 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755945Ab3KNTcP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 14:32:15 -0500
Received: by mail-pb0-f47.google.com with SMTP id rr4so999562pbb.6
        for <linux-scsi@vger.kernel.org>; Thu, 14 Nov 2013 11:32:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

ata: Add APM X-Gene SoC 6.0Gbps SATA PHY support

This patch adds support for APM X-Gene SoC 6.0Gbps SATA PHY. This is the
physical layer interface for the corresponding SATA host controller. This
driver uses the new PHY generic framework posted by Kishon Vijay Abrahm.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Olof Johansson <olof@lixom.net> 
---
Loc Ho (3):
  Documentation: Add APM X-Gene SATA PHY driver binding documentation
  ata: Add APM X-Gene SoC 6.0Gbps SATA PHY driver
  arm64: Add APM X-Gene SoC 6.0Gbps SATA PHY DTS entries.

 .../devicetree/bindings/ata/apm-xgene.txt          |   69 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   25 +
 drivers/ata/Kconfig                                |    6 +
 drivers/ata/Makefile                               |    1 +
 drivers/ata/sata_xgene_phy.c                       | 2142 ++++++++++++++++++++
 5 files changed, 2243 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene_phy.c

