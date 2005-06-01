From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 4/7] Open-iSCSI/Linux-iSCSI-5 High-Performance Initiator:
 iscsi-netlink.patch
Date: Wed, 01 Jun 2005 13:09:52 -0700
Message-ID: <429E1610.302@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp110.mail.sc5.yahoo.com ([66.163.170.8]:64652 "HELO
	smtp110.mail.sc5.yahoo.com") by vger.kernel.org with SMTP
	id S261164AbVFAUJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2005 16:09:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>

	iscsi-netlink.patch - include/linux/netlink.h changes (added NETLINK_ISCSI).

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Index: include/linux/netlink.h
===================================================================
--- 7570fde464d579ce455c865f07a613e967e9396c/include/linux/netlink.h  (mode:100644 sha1:f731abdc1a29a9cd1d5290d6a8121414377e88df)
+++ uncommitted/include/linux/netlink.h  (mode:100644)
@@ -14,6 +14,7 @@
 #define NETLINK_SELINUX		7	/* SELinux event notifications */
 #define NETLINK_ARPD		8
 #define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_ISCSI		10	/* iSCSI Open Interface */
 #define NETLINK_ROUTE6		11	/* af_inet6 route comm channel */
 #define NETLINK_IP6_FW		13
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */



