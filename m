From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 9/9] MAINTAINERS: Adding FCoE information to the MAINTAINERS
	file.
Date: Tue, 16 Feb 2010 12:16:00 -0800
Message-ID: <20100216201600.26581.47528.stgit@localhost.localdomain>
References: <20100216201513.26581.83756.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14429 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313Ab0BPUQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Feb 2010 15:16:01 -0500
In-Reply-To: <20100216201513.26581.83756.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3f59162..358a827 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2145,6 +2145,17 @@ S:	Supported
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

