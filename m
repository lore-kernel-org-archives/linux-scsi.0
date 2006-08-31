From: michaelc@cs.wisc.edu
Subject: [PATCH 12/12] iscsi class: update version
Date: Thu, 31 Aug 2006 18:09:35 -0400
Message-ID: <115706218934-git-send-email-michaelc@cs.wisc.edu>
References: <11570621752047-git-send-email-michaelc@cs.wisc.edu> <11570621761945-git-send-email-michaelc@cs.wisc.edu> <11570621781978-git-send-email-michaelc@cs.wisc.edu> <11570621791237-git-send-email-michaelc@cs.wisc.edu> <11570621801879-git-send-email-michaelc@cs.wisc.edu> <11570621821931-git-send-email-michaelc@cs.wisc.edu> <11570621832165-git-send-email-michaelc@cs.wisc.edu> <1157062184454-git-send-email-michaelc@cs.wisc.edu> <11570621852186-git-send-email-michaelc@cs.wisc.edu> <1157062186420-git-send-email-michaelc@cs.wisc.edu> <11570621871297-git-send-email-michaelc@cs.wisc.edu> <11570621882323-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37510 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932481AbWHaXJc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Aug 2006 19:09:32 -0400
In-Reply-To: <11570621882323-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Bump version.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 2ecd141..21bc5b2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -34,7 +34,7 @@ #include <scsi/iscsi_if.h>
 #define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 0
-#define ISCSI_TRANSPORT_VERSION "1.1-646"
+#define ISCSI_TRANSPORT_VERSION "2.0-685"
 
 struct iscsi_internal {
 	int daemon_pid;
-- 
1.4.1.1

