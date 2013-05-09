From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 1/8] iscsi_transport: Remove net param enum numbers
Date: Thu, 9 May 2013 06:02:05 -0400
Message-ID: <1368093732-8524-2-git-send-email-vikas.chaudhary@qlogic.com>
References: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:4137 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752942Ab3EIK0q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 May 2013 06:26:46 -0400
In-Reply-To: <1368093732-8524-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/scsi/iscsi_if.h | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index fe7f06c..2bc5d1c 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -377,25 +377,25 @@ struct iscsi_path {
 /* iSCSI network params */
 enum iscsi_net_param {
 	ISCSI_NET_PARAM_IPV4_ADDR		= 1,
-	ISCSI_NET_PARAM_IPV4_SUBNET		= 2,
-	ISCSI_NET_PARAM_IPV4_GW			= 3,
-	ISCSI_NET_PARAM_IPV4_BOOTPROTO		= 4,
-	ISCSI_NET_PARAM_MAC			= 5,
-	ISCSI_NET_PARAM_IPV6_LINKLOCAL		= 6,
-	ISCSI_NET_PARAM_IPV6_ADDR		= 7,
-	ISCSI_NET_PARAM_IPV6_ROUTER		= 8,
-	ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG	= 9,
-	ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG	= 10,
-	ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG	= 11,
-	ISCSI_NET_PARAM_IFACE_ENABLE		= 12,
-	ISCSI_NET_PARAM_VLAN_ID			= 13,
-	ISCSI_NET_PARAM_VLAN_PRIORITY		= 14,
-	ISCSI_NET_PARAM_VLAN_ENABLED		= 15,
-	ISCSI_NET_PARAM_VLAN_TAG		= 16,
-	ISCSI_NET_PARAM_IFACE_TYPE		= 17,
-	ISCSI_NET_PARAM_IFACE_NAME		= 18,
-	ISCSI_NET_PARAM_MTU			= 19,
-	ISCSI_NET_PARAM_PORT			= 20,
+	ISCSI_NET_PARAM_IPV4_SUBNET,
+	ISCSI_NET_PARAM_IPV4_GW,
+	ISCSI_NET_PARAM_IPV4_BOOTPROTO,
+	ISCSI_NET_PARAM_MAC,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL,
+	ISCSI_NET_PARAM_IPV6_ADDR,
+	ISCSI_NET_PARAM_IPV6_ROUTER,
+	ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG,
+	ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG,
+	ISCSI_NET_PARAM_IPV6_ROUTER_AUTOCFG,
+	ISCSI_NET_PARAM_IFACE_ENABLE,
+	ISCSI_NET_PARAM_VLAN_ID,
+	ISCSI_NET_PARAM_VLAN_PRIORITY,
+	ISCSI_NET_PARAM_VLAN_ENABLED,
+	ISCSI_NET_PARAM_VLAN_TAG,
+	ISCSI_NET_PARAM_IFACE_TYPE,
+	ISCSI_NET_PARAM_IFACE_NAME,
+	ISCSI_NET_PARAM_MTU,
+	ISCSI_NET_PARAM_PORT,
 };
 
 enum iscsi_conn_state {
-- 
1.8.2.GIT


