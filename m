From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH] [SCSI] Fix incorrect comment in scsi_logging.h
Date: Thu, 30 May 2013 09:35:15 -0400
Message-ID: <1369920915-15827-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229Ab3E3NfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 May 2013 09:35:16 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4UDZGOv005380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2013 09:35:16 -0400
Received: from emilne.csb (dhcp-185-251.bos.redhat.com [10.16.185.251])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r4UDZG2K012764
	for <linux-scsi@vger.kernel.org>; Thu, 30 May 2013 09:35:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

The scsi_logging_level word contains 10 3-bit fields,
not 8 nibbles.  Fix the incorrect comment.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_logging.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_logging.h b/drivers/scsi/scsi_logging.h
index 1f65139..bd6f58a 100644
--- a/drivers/scsi/scsi_logging.h
+++ b/drivers/scsi/scsi_logging.h
@@ -5,8 +5,8 @@
 /*
  * This defines the scsi logging feature.  It is a means by which the user
  * can select how much information they get about various goings on, and it
- * can be really useful for fault tracing.  The logging word is divided into
- * 8 nibbles, each of which describes a loglevel.  The division of things is
+ * can be really useful for fault tracing.  The logging word contains 10
+ * fields, each of which describes a loglevel.  The division of things is
  * somewhat arbitrary, and the division of the word could be changed if it
  * were really needed for any reason.  The numbers below are the only place
  * where these are specified.  For a first go-around, 3 bits is more than
-- 
1.7.11.7

