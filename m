From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH] scsi_transport_fc: add 64GBIT and 128GBIT port speed definitions
Date: Fri,  3 Nov 2017 16:26:08 -0700
Message-ID: <20171103232608.26460-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:47213 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752273AbdKCX0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 19:26:17 -0400
Received: by mail-qt0-f195.google.com with SMTP id z50so5120357qtj.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 16:26:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, James Smart <james.smart@broadcom.com>

Add 64GBIT and 128GBIT port speed definitions.

Upcoming hardware will reference these speeds.

Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/scsi_transport_fc.c | 2 ++
 include/scsi/scsi_transport_fc.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 3c6bc0081fcb..49058295d9bc 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -267,6 +267,8 @@ static const struct {
 	{ FC_PORTSPEED_50GBIT,		"50 Gbit" },
 	{ FC_PORTSPEED_100GBIT,		"100 Gbit" },
 	{ FC_PORTSPEED_25GBIT,		"25 Gbit" },
+	{ FC_PORTSPEED_64BIT,		"64 Gbit" },
+	{ FC_PORTSPEED_128BIT,		"128 Gbit" },
 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index e8644eea9fe5..8cf30215c177 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -139,6 +139,8 @@ enum fc_vport_state {
 #define FC_PORTSPEED_50GBIT		0x200
 #define FC_PORTSPEED_100GBIT		0x400
 #define FC_PORTSPEED_25GBIT		0x800
+#define FC_PORTSPEED_64BIT		0x1000
+#define FC_PORTSPEED_128BIT		0x2000
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*
-- 
2.13.1
