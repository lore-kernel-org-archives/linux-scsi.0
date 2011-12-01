From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 08/14] srp_transport: Document sysfs attributes
Date: Thu, 1 Dec 2011 20:05:02 +0100
Message-ID: <201112012005.02943.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:49009 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850Ab1LATFI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 14:05:08 -0500
In-Reply-To: <201112011954.25811.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

Document the srp_transport sysfs attributes according to the rules specified
in Documentation/ABI/README.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
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
1.7.3.4

