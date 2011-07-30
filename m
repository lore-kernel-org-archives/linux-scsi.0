From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/9] isci: Update MAINTAINERS entry for the isci driver
Date: Fri, 29 Jul 2011 17:16:55 -0700
Message-ID: <20110730001655.28430.80482.stgit@localhost6.localdomain6>
References: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:31888 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211Ab1G3AQ4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2011 20:16:56 -0400
In-Reply-To: <20110730001320.28430.53496.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 187282d..cf3ea1f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3240,6 +3240,17 @@ F:	Documentation/input/multi-touch-protocol.txt
 F:	drivers/input/input-mt.c
 K:	\b(ABS|SYN)_MT_
 
+INTEL C600 SERIES SAS CONTROLLER DRIVER
+M:	Intel SCU Linux support <intel-linux-scu@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
+M:	Ed Nadolski <edmund.nadolski@intel.com>
+L:	linux-scsi@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
+S:	Maintained
+F:	drivers/scsi/isci/
+F:	firmware/isci/
+
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
 L:	linux-pm@lists.linux-foundation.org

