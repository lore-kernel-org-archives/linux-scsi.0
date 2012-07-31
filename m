From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH] ibmvscsi: Add maintainer for IBM virtual SCSI/FC drivers
Date: Tue, 31 Jul 2012 12:34:36 -0500
Message-ID: <20120731173436.GA2601@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Add a MAINTAINERS entry for the IBM Power Virtual SCSI and FC device
drivers.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fb036a0..f441c46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3425,6 +3425,13 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/ibm/ibmveth.*
 
+IBM Power Virtual SCSI/FC Device Drivers
+M:	Robert Jennings <rcj@linux.vnet.ibm.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ibmvscsi/
+X:	drivers/scsi/ibmvscsi/ibmvstgt.c
+
 IBM ServeRAID RAID DRIVER
 P:	Jack Hammer
 M:	Dave Jeffery <ipslinux@adaptec.com>
-- 
1.7.0.4
