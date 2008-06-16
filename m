From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] iscsi class: update version number
Date: Mon, 16 Jun 2008 10:11:34 -0500
Message-ID: <1213629095-5078-4-git-send-email-michaelc@cs.wisc.edu>
References: <1213629095-5078-1-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-2-git-send-email-michaelc@cs.wisc.edu>
 <1213629095-5078-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbYFPPMB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 11:12:01 -0400
In-Reply-To: <1213629095-5078-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Update iscsi class version number.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index bc0f74d..8e34f3c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -34,7 +34,7 @@
 #define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
 
-#define ISCSI_TRANSPORT_VERSION "2.0-869"
+#define ISCSI_TRANSPORT_VERSION "2.0-870"
 
 struct iscsi_internal {
 	int daemon_pid;
-- 
1.5.4.1

