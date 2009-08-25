From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 06/64] libfc: Export FC headers
Date: Tue, 25 Aug 2009 13:58:58 -0700
Message-ID: <20090825205858.1553.17654.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61754 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755523AbZHYU6z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:55 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>

Export fc_els.h, fc_fs.h, fc_gs.h and fc_ns.h so that they
may be used by applications.

This will be needed for FC Passthrough applications like fcping,
but could be used by other applications.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 include/scsi/Kbuild    |    1 +
 include/scsi/fc/Kbuild |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)
 create mode 100644 include/scsi/fc/Kbuild

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index 33b2750..b3a0ee6 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -2,3 +2,4 @@ header-y += scsi.h
 header-y += scsi_netlink.h
 header-y += scsi_netlink_fc.h
 header-y += scsi_bsg_fc.h
+header-y += fc/
diff --git a/include/scsi/fc/Kbuild b/include/scsi/fc/Kbuild
new file mode 100644
index 0000000..5660381
--- /dev/null
+++ b/include/scsi/fc/Kbuild
@@ -0,0 +1,4 @@
+header-y += fc_els.h
+header-y += fc_fs.h
+header-y += fc_gs.h
+header-y += fc_ns.h

