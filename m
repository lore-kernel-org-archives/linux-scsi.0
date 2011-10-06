From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] iscsi class: fix link local mispelling
Date: Thu,  6 Oct 2011 03:56:58 -0500
Message-ID: <1317891420-7116-3-git-send-email-michaelc@cs.wisc.edu>
References: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757839Ab1JFIv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Oct 2011 04:51:58 -0400
In-Reply-To: <1317891420-7116-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Use the same format for link local variables. Instead
of linklocal do link_local.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index d746c35..522423b 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -317,7 +317,7 @@ iscsi_iface_net_attr(ipv6_iface, link_local_addr, ISCSI_NET_PARAM_IPV6_LINKLOCAL
 iscsi_iface_net_attr(ipv6_iface, router_addr, ISCSI_NET_PARAM_IPV6_ROUTER);
 iscsi_iface_net_attr(ipv6_iface, ipaddr_autocfg,
 		     ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG);
-iscsi_iface_net_attr(ipv6_iface, linklocal_autocfg,
+iscsi_iface_net_attr(ipv6_iface, link_local_autocfg,
 		     ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG);
 
 /* common read only iface attribute */
@@ -368,7 +368,7 @@ static mode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 			param = ISCSI_NET_PARAM_IPV6_ROUTER;
 		else if (attr == &dev_attr_ipv6_iface_ipaddr_autocfg.attr)
 			param = ISCSI_NET_PARAM_IPV6_ADDR_AUTOCFG;
-		else if (attr == &dev_attr_ipv6_iface_linklocal_autocfg.attr)
+		else if (attr == &dev_attr_ipv6_iface_link_local_autocfg.attr)
 			param = ISCSI_NET_PARAM_IPV6_LINKLOCAL_AUTOCFG;
 		else
 			return 0;
@@ -393,7 +393,7 @@ static struct attribute *iscsi_iface_attrs[] = {
 	&dev_attr_ipv6_iface_link_local_addr.attr,
 	&dev_attr_ipv6_iface_router_addr.attr,
 	&dev_attr_ipv6_iface_ipaddr_autocfg.attr,
-	&dev_attr_ipv6_iface_linklocal_autocfg.attr,
+	&dev_attr_ipv6_iface_link_local_autocfg.attr,
 	&dev_attr_iface_mtu.attr,
 	&dev_attr_iface_port.attr,
 	NULL,
-- 
1.7.6

