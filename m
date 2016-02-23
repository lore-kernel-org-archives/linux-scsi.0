From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 7/7] hpsa: update copyright information
Date: Tue, 23 Feb 2016 15:16:46 -0600
Message-ID: <20160223211646.5968.65110.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37236 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212AbcBWVQs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:48 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c     |    3 ++-
 drivers/scsi/hpsa.h     |    3 ++-
 drivers/scsi/hpsa_cmd.h |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 725eb8d..5be944c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
@@ -12,7 +13,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    Questions/Comments/Bugfixes to storagedev@pmcs.com
+ *    Questions/Comments/Bugfixes to esc.storagedev@microsemi.com
  *
  */
 
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index fdd39fc..d06bb74 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
@@ -12,7 +13,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    Questions/Comments/Bugfixes to storagedev@pmcs.com
+ *    Questions/Comments/Bugfixes to esc.storagedev@microsemi.com
  *
  */
 #ifndef HPSA_H
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index dffda96..a5be153 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -1,5 +1,6 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
+ *    Copyright 2016 Microsemi Corporation
  *    Copyright 2014-2015 PMC-Sierra, Inc.
  *    Copyright 2000,2009-2015 Hewlett-Packard Development Company, L.P.
  *
@@ -12,7 +13,7 @@
  *    MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
  *    NON INFRINGEMENT.  See the GNU General Public License for more details.
  *
- *    Questions/Comments/Bugfixes to storagedev@pmcs.com
+ *    Questions/Comments/Bugfixes to esc.storagedev@microsemi.com
  *
  */
 #ifndef HPSA_CMD_H

