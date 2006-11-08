From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/4] iscsi class: update version
Date: Wed, 08 Nov 2006 15:58:34 -0600
Message-ID: <11630231171946-git-send-email-michaelc@cs.wisc.edu>
References: <11630231143038-git-send-email-michaelc@cs.wisc.edu> <11630231152581-git-send-email-michaelc@cs.wisc.edu> <11630231161743-git-send-email-michaelc@cs.wisc.edu> <1163023116954-git-send-email-michaelc@cs.wisc.edu>
Reply-To: Mike Christie <michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39066 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965728AbWKHV6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 16:58:44 -0500
In-Reply-To: <1163023116954-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Update version number
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2d3baa9..9b25124 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -33,7 +33,7 @@ #include <scsi/iscsi_if.h>
 #define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 0
-#define ISCSI_TRANSPORT_VERSION "2.0-685"
+#define ISCSI_TRANSPORT_VERSION "2.0-724"
 
 struct iscsi_internal {
 	int daemon_pid;
-- 
1.4.1.1

