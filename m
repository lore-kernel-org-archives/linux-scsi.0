From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v2 13/17] scsi_transport_iscsi: Add 25G and 40G speed definition
Date: Tue, 22 Dec 2015 22:45:58 +0530
Message-ID: <1450804562-11980-14-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:49452 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754728AbbLVRQk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 12:16:40 -0500
In-Reply-To: <1450804562-11980-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

iscsi_port_speed and iscsi_port_speed_names have new entries for
25Gbps and 40Gbps link speeds.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 2 ++
 include/scsi/iscsi_if.h             | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index e4b3d8f..4414816 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -4308,6 +4308,8 @@ static const struct {
 	{ISCSI_PORT_SPEED_100MBPS,	"100 Mbps" },
 	{ISCSI_PORT_SPEED_1GBPS,	"1 Gbps" },
 	{ISCSI_PORT_SPEED_10GBPS,	"10 Gbps" },
+	{ISCSI_PORT_SPEED_25GBPS,       "25 Gbps" },
+	{ISCSI_PORT_SPEED_40GBPS,       "40 Gbps" },
 };
 
 char *iscsi_get_port_speed_name(struct Scsi_Host *shost)
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 95ed942..d66c070 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -724,6 +724,8 @@ enum iscsi_port_speed {
 	ISCSI_PORT_SPEED_100MBPS	= 0x4,
 	ISCSI_PORT_SPEED_1GBPS		= 0x8,
 	ISCSI_PORT_SPEED_10GBPS		= 0x10,
+	ISCSI_PORT_SPEED_25GBPS         = 0x20,
+	ISCSI_PORT_SPEED_40GBPS         = 0x40,
 };
 
 /* iSCSI port state */
-- 
1.9.1

