From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 42/43] hpsa: add PMC to copyright
Date: Thu, 16 Apr 2015 08:50:32 -0500
Message-ID: <20150416135032.30238.85284.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:35469 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbbDPNvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:51:33 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

need to add PMC to copyright notice and update the Hewlett-Packard
copyright notification.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c     |    3 ++-
 drivers/scsi/hpsa.h     |    3 ++-
 drivers/scsi/hpsa_cmd.h |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4b4df66..5fc4118 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Portions Copyright 2008-2014 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 6ee4da6..80cfc79 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Portions Copyright 2008-2014 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/hpsa_cmd.h b/drivers/scsi/hpsa_cmd.h
index c601622..23a8f0d 100644
--- a/drivers/scsi/hpsa_cmd.h
+++ b/drivers/scsi/hpsa_cmd.h
@@ -1,6 +1,7 @@
 /*
  *    Disk Array driver for HP Smart Array SAS controllers
- *    Copyright 2000, 2014 Hewlett-Packard Development Company, L.P.
+ *    Copyright 2014-2015 PMC-Sierra, Inc.
+ *    Portions Copyright 2008-2014 Hewlett-Packard Development Company, L.P.
  *
  *    This program is free software; you can redistribute it and/or modify
  *    it under the terms of the GNU General Public License as published by

