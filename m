From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 5/6] Linux-iSCSI High-Performance Initiator
Date: Mon, 11 Apr 2005 20:24:42 -0700
Message-ID: <425B3F7A.7020501@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040906020700010701040909"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp012.mail.yahoo.com ([216.136.173.32]:32873 "HELO
	smtp012.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262014AbVDLDZA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 23:25:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040906020700010701040909
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

             include/linux/netlink.h changes (added NETLINK_ISCSI)

             Signed-off-by: Alex Aizman <itn780@yahoo.com>
             Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>












--------------040906020700010701040909
Content-Type: text/plain;
 name="linux-iscsi-netlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-iscsi-netlink.patch"

--- linux-2.6.12-rc2.orig/include/linux/netlink.h	2005-03-01 23:38:25.000000000 -0800
+++ linux-2.6.12-rc2.dima/include/linux/netlink.h	2005-04-11 18:13:12.000000000 -0700
@@ -14,6 +14,7 @@
 #define NETLINK_SELINUX		7	/* SELinux event notifications */
 #define NETLINK_ARPD		8
 #define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_ISCSI		10	/* iSCSI Open Interface */
 #define NETLINK_ROUTE6		11	/* af_inet6 route comm channel */
 #define NETLINK_IP6_FW		13
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */



--------------040906020700010701040909--
