From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 5/6] Open-iSCSI High-Performance Initiator for Linux
Date: Sun, 06 Mar 2005 23:16:07 -0800
Message-ID: <422BFFB7.4000206@yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030107000802070201010200"
Received: from smtp017.mail.yahoo.com ([216.136.174.114]:63620 "HELO
	smtp017.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261671AbVCGHQh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2005 02:16:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030107000802070201010200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

          include/linux/netlink.h changes (added new protocol NETLINK_ISCSI)

          Signed-off-by: Alex Aizman <itn780@yahoo.com>
          Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>









--------------030107000802070201010200
Content-Type: text/plain;
 name="open-iscsi-netlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="open-iscsi-netlink.patch"

--- linux-2.6.11.orig/include/linux/netlink.h	2005-03-01 23:38:25.000000000 -0800
+++ linux-2.6.11.dima/include/linux/netlink.h	2005-03-04 17:50:11.143413101 -0800
@@ -14,6 +14,7 @@
 #define NETLINK_SELINUX		7	/* SELinux event notifications */
 #define NETLINK_ARPD		8
 #define NETLINK_AUDIT		9	/* auditing */
+#define NETLINK_ISCSI		10	/* iSCSI Open Interface */
 #define NETLINK_ROUTE6		11	/* af_inet6 route comm channel */
 #define NETLINK_IP6_FW		13
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */










--------------030107000802070201010200--
