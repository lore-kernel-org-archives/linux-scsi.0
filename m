From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 42/42] hpsa: add PMC to copyright
Date: Tue, 17 Mar 2015 15:07:17 -0500
Message-ID: <20150317200717.19856.34699.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42610 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbbCQUI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:08:57 -0400
Received: from g9t5008.houston.hp.com (g9t5008.houston.hp.com [15.240.92.66])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B3B8064382
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:08:56 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
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
index 893bb50..33ad6eb 100644
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

