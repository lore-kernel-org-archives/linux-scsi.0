From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH V2 10/20] scsi_transport_fc: Add 32Gbps speed definition.
Date: Mon, 16 Dec 2013 22:28:33 -0500
Message-ID: <1387250923-1041-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:37979 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752556Ab3LQEBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 23:01:36 -0500
In-Reply-To: <1387250923-1041-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Chad Dupuis <chad.dupuis@qlogic.com>

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/scsi_transport_fc.c |    1 +
 include/scsi/scsi_transport_fc.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 4628fd5..f80908f 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -261,6 +261,7 @@ static const struct {
 	{ FC_PORTSPEED_10GBIT,		"10 Gbit" },
 	{ FC_PORTSPEED_8GBIT,		"8 Gbit" },
 	{ FC_PORTSPEED_16GBIT,		"16 Gbit" },
+	{ FC_PORTSPEED_32GBIT,		"32 Gbit" },
 	{ FC_PORTSPEED_NOT_NEGOTIATED,	"Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index b797e8f..8c79980 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -130,6 +130,7 @@ enum fc_vport_state {
 #define FC_PORTSPEED_4GBIT		8
 #define FC_PORTSPEED_8GBIT		0x10
 #define FC_PORTSPEED_16GBIT		0x20
+#define FC_PORTSPEED_32GBIT		0x40
 #define FC_PORTSPEED_NOT_NEGOTIATED	(1 << 15) /* Speed not established */
 
 /*
-- 
1.7.7

