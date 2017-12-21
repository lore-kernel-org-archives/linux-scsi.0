From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] scsi: scsi_transport_fc: fix typos on 64/128 GBit define names
Date: Thu, 21 Dec 2017 14:25:52 -0800
Message-ID: <20171221222552.12470-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:39419 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752402AbdLUW0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Dec 2017 17:26:01 -0500
Received: by mail-qk0-f195.google.com with SMTP id u184so32769868qkd.6
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 14:26:00 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>

The define names specified 64Bit/128Bit, not 64GBIT/128GBIT.
Correct the names.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 4 ++--
 include/scsi/scsi_transport_fc.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4664024bd5d3..be3be0f9cb2d 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -267,8 +267,8 @@ static const struct {
 	{ FC_PORTSPEED_50GBIT,		"50 Gbit" },
 	{ FC_PORTSPEED_100GBIT,		"100 Gbit" },
 	{ FC_PORTSPEED_25GBIT,		"25 Gbit" },
-	{ FC_PORTSPEED_64BIT,		"64 Gbit" },
-	{ FC_PORTSPEED_128BIT,		"128 Gbit" },
+	{ FC_PORTSPEED_64GBIT,		"64 Gbit" },
+	{ FC_PORTSPEED_128GBIT,		"128 Gbit" },
 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 8cf30215c177..15da45dc2a5d 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -139,8 +139,8 @@ enum fc_vport_state {
 #define FC_PORTSPEED_50GBIT		0x200
 #define FC_PORTSPEED_100GBIT		0x400
 #define FC_PORTSPEED_25GBIT		0x800
-#define FC_PORTSPEED_64BIT		0x1000
-#define FC_PORTSPEED_128BIT		0x2000
+#define FC_PORTSPEED_64GBIT		0x1000
+#define FC_PORTSPEED_128GBIT		0x2000
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*
-- 
2.13.1
