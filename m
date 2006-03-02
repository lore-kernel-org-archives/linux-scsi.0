From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] add 6.0 Gbit phy definitions to the sas transport class
Date: Thu, 02 Mar 2006 14:12:56 -0600
Message-ID: <1141330376.3238.51.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:61365 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932189AbWCBUM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 15:12:57 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k22KCu215979
	for <linux-scsi@vger.kernel.org>; Thu, 2 Mar 2006 15:12:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I don't think these exist in silicon yet, but the aic94xx driver has a
register setting for them.

James

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index eab5c7c..2fa63ff 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -151,6 +151,7 @@ static struct {
 	{ SAS_SATA_SPINUP_HOLD,		"Spin-up hold" },
 	{ SAS_LINK_RATE_1_5_GBPS,	"1.5 Gbit" },
 	{ SAS_LINK_RATE_3_0_GBPS,	"3.0 Gbit" },
+	{ SAS_LINK_RATE_6_0_GBPS,	"6.0 Gbit" },
 };
 sas_bitfield_name_search(linkspeed, sas_linkspeed_names)
 
diff --git a/include/scsi/scsi_transport_sas.h b/include/scsi/scsi_transport_sas.h
index ccef5d2..95e2132 100644
--- a/include/scsi/scsi_transport_sas.h
+++ b/include/scsi/scsi_transport_sas.h
@@ -30,6 +30,7 @@ enum sas_linkrate {
 	SAS_SATA_PORT_SELECTOR,
 	SAS_LINK_RATE_1_5_GBPS,
 	SAS_LINK_RATE_3_0_GBPS,
+	SAS_LINK_RATE_6_0_GBPS,
 	SAS_LINK_VIRTUAL,
 };
 


