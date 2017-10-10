From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: logging_level: update bits description
Date: Tue, 10 Oct 2017 12:05:54 -0700
Message-ID: <7d747a9b-e0a0-0f64-f1f3-66338ec7bbea@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59112 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932087AbdJJTF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 15:05:57 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

From: Randy Dunlap <rdunlap@infradead.org>

Update the description of 'scsi_logging_level' from 8 4-bit nibbles
to the (pre-git) reality of 10 3-bit 'nibbles'.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/scsi/scsi_logging.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- lnx-414-rc3.orig/drivers/scsi/scsi_logging.h
+++ lnx-414-rc3/drivers/scsi/scsi_logging.h
@@ -3,10 +3,10 @@
 
 
 /*
- * This defines the scsi logging feature.  It is a means by which the user
- * can select how much information they get about various goings on, and it
- * can be really useful for fault tracing.  The logging word is divided into
- * 8 nibbles, each of which describes a loglevel.  The division of things is
+ * This defines the scsi logging feature.  It is a means by which the user can
+ * select how much information they get about various goings on, and it can be
+ * really useful for fault tracing.  The logging word is divided into 10 3-bit
+ * 'nibbles', each of which describes a loglevel.  The division of things is
  * somewhat arbitrary, and the division of the word could be changed if it
  * were really needed for any reason.  The numbers below are the only place
  * where these are specified.  For a first go-around, 3 bits is more than
