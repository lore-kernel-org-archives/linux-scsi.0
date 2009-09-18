From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 24/24] MAINTAINERS: Update for libfc, libfcoe, fcoe
Date: Fri, 18 Sep 2009 15:51:10 -0700
Message-ID: <20090918225110.5928.8928.stgit@localhost.localdomain>
References: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2918 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758865AbZIRWvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:51:06 -0400
In-Reply-To: <20090918224847.5928.52092.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Adding FCoE information to the MAINTAINERS file.
---

 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9117b65..869d6e5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2004,6 +2004,17 @@ S:	Supported
 F:	Documentation/fault-injection/
 F:	lib/fault-inject.c
 
+FCOE SUBSYSTEM (libfc, libfcoe, fcoe)
+M:	Robert Love <robert.w.love@intel.com>
+L:	devel@open-fcoe.org
+W:	www.Open-FCoE.org
+S:	Supported
+F:	drivers/scsi/libfc/
+F:	drivers/scsi/fcoe/
+F:	include/scsi/fc/
+F:	include/scsi/libfc.h
+F:	include/scsi/libfcoe.h
+
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Matthew Wilcox <matthew@wil.cx>
 L:	linux-fsdevel@vger.kernel.org

