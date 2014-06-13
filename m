From: Dick Kennedy <Dick.Kennedy@Emulex.Com>
Subject: [PATCH 1/1] Add defines for new FC port speeds.
Date: Fri, 13 Jun 2014 16:40:36 +0000
Message-ID: <814CB474615D9040840B5BA11313B6CB3D85763C@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44804 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMQki convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 12:40:38 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

These speeds are to support the next generation of FCoE port speeds.
Signed-off-by: rkennedy@emulex.com
---
 drivers/scsi/scsi_transport_fc.c |    4 ++++
 include/scsi/scsi_transport_fc.h |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index f80908f..454cc28 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -262,6 +262,10 @@ static const struct {
        { FC_PORTSPEED_8GBIT,           "8 Gbit" },
        { FC_PORTSPEED_16GBIT,          "16 Gbit" },
        { FC_PORTSPEED_32GBIT,          "32 Gbit" },
+       { FC_PORTSPEED_20GBIT,          "20 Gbit" },
+       { FC_PORTSPEED_40GBIT,          "40 Gbit" },
+       { FC_PORTSPEED_50GBIT,          "50 Gbit" },
+       { FC_PORTSPEED_100GBIT,         "100 Gbit" },
        { FC_PORTSPEED_NOT_NEGOTIATED,  "Not Negotiated" },
 };
 fc_bitfield_name_search(port_speed, fc_port_speed_names)
diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transport_fc.h
index 8c79980..007a0bc 100644
--- a/include/scsi/scsi_transport_fc.h
+++ b/include/scsi/scsi_transport_fc.h
@@ -131,6 +131,10 @@ enum fc_vport_state {
 #define FC_PORTSPEED_8GBIT             0x10
 #define FC_PORTSPEED_16GBIT            0x20
 #define FC_PORTSPEED_32GBIT            0x40
+#define FC_PORTSPEED_20GBIT            0x80
+#define FC_PORTSPEED_40GBIT            0x100
+#define FC_PORTSPEED_50GBIT            0x200
+#define FC_PORTSPEED_100GBIT           0x400
 #define FC_PORTSPEED_NOT_NEGOTIATED    (1 << 15) /* Speed not established */

 /*
--
1.6.6
