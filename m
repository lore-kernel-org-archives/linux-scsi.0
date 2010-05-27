From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 24/24] hpsa: add entry to MAINTAINERS
Date: Thu, 27 May 2010 15:14:44 -0500
Message-ID: <20100527201444.3116.88070.stgit@beardog.cce.hp.com>
References: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0016.houston.hp.com ([15.201.24.19]:26517 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab0E0UKF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2010 16:10:05 -0400
In-Reply-To: <20100527200301.3116.78973.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, dab@hp.com, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: add entry to MAINTAINERS

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d329b05..f400f81 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2569,6 +2569,14 @@ S:	Maintained
 F:	Documentation/blockdev/cpqarray.txt
 F:	drivers/block/cpqarray.*
 
+HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
+M:	Stephen M. Cameron <scameron@beardog.cce.hp.com>
+L:	iss_storagedev@hp.com
+S:	Supported
+F:	Documentation/scsi/hpsa.txt
+F:	drivers/scsi/hpsa*.[ch]
+F:	include/linux/cciss*.h
+
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Mike Miller <mike.miller@hp.com>
 L:	iss_storagedev@hp.com

