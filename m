From: <adheer.chandravanshi@qlogic.com>
Subject: [PATCH V2 1/4] iscsi_transport: Remove net param enum values
Date: Fri, 18 Oct 2013 09:01:40 -0400
Message-ID: <1382101303-3420-2-git-send-email-adheer.chandravanshi@qlogic.com>
References: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:30648 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab3JRNeV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Oct 2013 09:34:21 -0400
In-Reply-To: <1382101303-3420-1-git-send-email-adheer.chandravanshi@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Harish Zunjarrao <harish.zunjarrao@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

Remove explicit values assignment for net param enums.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 include/scsi/iscsi_if.h |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 5d6ed6c..765c982 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -386,25 +386,25 @@ struct iscsi_path {
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
1.7.1

