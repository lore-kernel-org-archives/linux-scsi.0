From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 4/7] open-iscsi/linux-iscsi-5 Initiator: open-iscsi-netlink.patch
Date: Thu, 04 Aug 2005 19:31:18 -0700
Message-ID: <42F2CF76.3040209@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp012.mail.yahoo.com ([216.136.173.32]:53364 "HELO
	smtp012.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262818AbVHECb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 22:31:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

	open-iscsi-netlink.patch - include/linux/netlink.h changes (added NETLINK_ISCSI).

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -22,6 +22,7 @@
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_TAPBASE		16	/* 16 to 31 are ethertap */
 
+#define NETLINK_ISCSI		31	/* iSCSI Open Interface */
 #define MAX_LINKS 32		
 
 struct sockaddr_nl


