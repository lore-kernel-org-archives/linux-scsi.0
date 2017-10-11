From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] scsi: logging: update description of logging_level bits
Date: Wed, 11 Oct 2017 10:09:23 -0700
Message-ID: <405824b6-5dd7-dc34-55a9-c11f69e2fabd@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:51810 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752634AbdJKRJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Oct 2017 13:09:28 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Kyle Fortin <kyle.fortin@oracle.com>, Steffen Maier <maier@linux.vnet.ibm.com>

From: Randy Dunlap <rdunlap@infradead.org>

Update the description of 'scsi_logging_level' from 8 4-bit nibbles
to the (pre-git) reality of 10 3-bit bitfields.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Kyle Fortin <kyle.fortin@oracle.com>
Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/scsi/scsi_logging.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

v2: change 3-bit 'nibbles' to 3-bit bitfields.
    add Reviewed-bys.

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
+ * bitfields, each of which describes a loglevel.  The division of things is
  * somewhat arbitrary, and the division of the word could be changed if it
  * were really needed for any reason.  The numbers below are the only place
  * where these are specified.  For a first go-around, 3 bits is more than
