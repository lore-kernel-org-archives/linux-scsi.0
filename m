From: Loc Ho <lho@apm.com>
Subject: [PATCH v2 0/5] ata: Add APM X-Gene SATA controller support
Date: Sat,  9 Nov 2013 00:00:26 -0700
Message-ID: <1383980431-6572-1-git-send-email-lho@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:60539 "HELO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753736Ab3KIHAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 02:00:39 -0500
Received: by mail-pd0-f177.google.com with SMTP id p10so3084161pdj.22
        for <linux-scsi@vger.kernel.org>; Fri, 08 Nov 2013 23:00:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, jcm@redhat.com, Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

ata: Add APM X-Gene SATA controller support

v2:
 * Clean up file sata_xgene.c with Lindent and etc
 * Clean up file sata_xgene_serdes.c with Lindent and etc
 * Add description to each patch

v1:
 * inital version

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Tuan Phan <tphan@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
Loc Ho (5):
  ata: Export AHCI library functions required by APM X-Gene SATA driver
  arm64: Add APM X-Gene DTS entry for SATA controllers
  ata: Add APM X-Gene SATA driver
  ata: Add APM X-Gene SATA serdes functions
  Documentation: Add documentation for APM X-Gene SATA DTS binding

 .../devicetree/bindings/ata/apm-xgene.txt          |   84 +
 arch/arm64/boot/dts/apm-storm.dtsi                 |   73 +
 drivers/ata/Kconfig                                |    7 +
 drivers/ata/Makefile                               |    2 +
 drivers/ata/ahci.h                                 |    6 +
 drivers/ata/libahci.c                              |   13 +-
 drivers/ata/sata_xgene.c                           | 1394 ++++++++++++++
 drivers/ata/sata_xgene.h                           |  112 ++
 drivers/ata/sata_xgene_serdes.c                    | 2004 ++++++++++++++++++++
 9 files changed, 3690 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
 create mode 100644 drivers/ata/sata_xgene.c
 create mode 100644 drivers/ata/sata_xgene.h
 create mode 100644 drivers/ata/sata_xgene_serdes.c

