From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH 10/11] srp_transport: Document sysfs attributes
Date: Sun, 25 Nov 2012 23:44:15 -0500
Message-ID: <a529b3922e12a1f880ddf4c79336f24361142c02.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38059 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2KZEzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 23:55:10 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, roland@purestorage.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Robert Jennings <rcj@linux.vnet.ibm.com>

From: Bart Van Assche <bvanassche@acm.org>

Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 Documentation/ABI/stable/sysfs-transport-srp |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
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
1.7.7.6

