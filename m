From: michaelc@cs.wisc.edu
Subject: [PATCH 24/24] iscsi class: bump version
Date: Thu, 13 Dec 2007 12:43:43 -0600
Message-ID: <1197571458603-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
 <119757143673-git-send-email-michaelc@cs.wisc.edu>
 <11975714363904-git-send-email-michaelc@cs.wisc.edu>
 <11975714372848-git-send-email-michaelc@cs.wisc.edu>
 <11975714382641-git-send-email-michaelc@cs.wisc.edu>
 <11975714404116-git-send-email-michaelc@cs.wisc.edu>
 <11975714413336-git-send-email-michaelc@cs.wisc.edu>
 <1197571442630-git-send-email-michaelc@cs.wisc.edu>
 <11975714441250-git-send-email-michaelc@cs.wisc.edu>
 <1197571445685-git-send-email-michaelc@cs.wisc.edu>
 <1197571447387-git-send-email-michaelc@cs.wisc.edu>
 <1197571448857-git-send-email-michaelc@cs.wisc.edu>
 <11975714503562-git-send-email-michaelc@cs.wisc.edu>
 <1197571451503-git-send-email-michaelc@cs.wisc.edu>
 <1197571453148-git-send-email-michaelc@cs.wisc.edu>
 <11975714543562-git-send-email-michaelc@cs.wisc.edu>
 <11975714563205-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538AbXLMSoV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:21 -0500
In-Reply-To: <11975714563205-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Update version.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 3585599..ef0e742 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -33,7 +33,7 @@
 #define ISCSI_SESSION_ATTRS 18
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 4
-#define ISCSI_TRANSPORT_VERSION "2.0-724"
+#define ISCSI_TRANSPORT_VERSION "2.0-867"
 
 struct iscsi_internal {
 	int daemon_pid;
-- 
1.5.1.2

