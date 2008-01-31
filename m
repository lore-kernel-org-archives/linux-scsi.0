From: michaelc@cs.wisc.edu
Subject: [PATCH 09/12] iscsi class: fix iscsi conn attr counter
Date: Thu, 31 Jan 2008 13:36:51 -0600
Message-ID: <12018082172234-git-send-email-michaelc@cs.wisc.edu>
References: <12018082143359-git-send-email-michaelc@cs.wisc.edu>
 <12018082142447-git-send-email-michaelc@cs.wisc.edu>
 <1201808215968-git-send-email-michaelc@cs.wisc.edu>
 <1201808215955-git-send-email-michaelc@cs.wisc.edu>
 <12018082162624-git-send-email-michaelc@cs.wisc.edu>
 <12018082161847-git-send-email-michaelc@cs.wisc.edu>
 <1201808216137-git-send-email-michaelc@cs.wisc.edu>
 <12018082174157-git-send-email-michaelc@cs.wisc.edu>
 <1201808217738-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759751AbYAaThB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 14:37:01 -0500
In-Reply-To: <1201808217738-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There are 13 iscsi conn attrs, but since the IF/OF markers were not being
used we did not notice that we forgot to increment the ISCSI_CONN_ATTRS
counter.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index af17997..35834bf 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -31,7 +31,7 @@
 #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 19
-#define ISCSI_CONN_ATTRS 11
+#define ISCSI_CONN_ATTRS 13
 #define ISCSI_HOST_ATTRS 4
 #define ISCSI_TRANSPORT_VERSION "2.0-867"
 
-- 
1.5.2.1

