From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 11/18] srp_transport: Document sysfs attributes
Date: Sat, 14 Jan 2012 12:50:18 +0000
Message-ID: <3168021.OYLy8v0FHd@asus>
References: <3109536.qySrY1Ts3e@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:46915 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab2ANMuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jan 2012 07:50:21 -0500
In-Reply-To: <3109536.qySrY1Ts3e@asus>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, David Dillow <dillowda@ornl.gov>, Roland Dreier <roland@purestorage.com>

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Roland Dreier <roland@purestorage.com>
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
1.7.7


