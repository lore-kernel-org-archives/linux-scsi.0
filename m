From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 13/19] srp_transport: Document sysfs attributes
Date: Fri, 26 Oct 2012 14:54:17 +0200
Message-ID: <508A87F9.507@acm.org>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:43213 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab2JZMyU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:54:20 -0400
In-Reply-To: <508A85BB.1000505@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Robert Jennings <rcj@linux.vnet.ibm.com>

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 Documentation/ABI/stable/sysfs-transport-srp |   12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/ABI/stable/sysfs-transport-srp

diff --git a/Documentation/ABI/stable/sysfs-transport-srp b/Documentation/ABI/stable/sysfs-transport-srp
new file mode 100644
index 0000000..7b0d4a5
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-transport-srp
@@ -0,0 +1,12 @@
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/port_id
+Date:		June 27, 2007
+KernelVersion:	2.6.24
+Contact:	linux-scsi@vger.kernel.org
+Description:	16-byte local SRP port identifier in hexadecimal format. An
+		example: 4c:49:4e:55:58:20:56:49:4f:00:00:00:00:00:00:00.
+
+What:		/sys/class/srp_remote_ports/port-<h>:<n>/roles
+Date:		June 27, 2007
+KernelVersion:	2.6.24
+Contact:	linux-scsi@vger.kernel.org
+Description:	Role of the remote port. Either "SRP Initiator" or "SRP Target".
-- 
1.7.10.4

