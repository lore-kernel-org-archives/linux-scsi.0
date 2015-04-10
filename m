From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 2/4] cxgbi: update copyright to 2015
Date: Fri, 10 Apr 2015 13:57:15 -0700
Message-ID: <201504102057.t3AKvFGN028760@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:23985 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbbDJVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 17:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

Update copyright to 2015.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.h |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    2 +-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.h |    2 +-
 drivers/scsi/cxgbi/libcxgbi.c      |    2 +-
 drivers/scsi/cxgbi/libcxgbi.h      |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 6018f92..a9ddddd 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -1,7 +1,7 @@
 /*
  * cxgb3i_offload.c: Chelsio S3xx iscsi offloaded tcp connection management
  *
- * Copyright (C) 2003-2008 Chelsio Communications.  All rights reserved.
+ * Copyright (C) 2003-2015 Chelsio Communications.  All rights reserved.
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
index 20593fd..b0430c9 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.h
@@ -1,7 +1,7 @@
 /*
  * cxgb3i.h: Chelsio S3xx iSCSI driver.
  *
- * Copyright (c) 2008 Chelsio Communications, Inc.
+ * Copyright (c) 2008-2015 Chelsio Communications, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index b131895..fabd365 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1,7 +1,7 @@
 /*
  * cxgb4i.c: Chelsio T4 iSCSI driver.
  *
- * Copyright (c) 2010 Chelsio Communications, Inc.
+ * Copyright (c) 2010-2015 Chelsio Communications, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
index 1096026..63115bc 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.h
@@ -1,7 +1,7 @@
 /*
  * cxgb4i.h: Chelsio T4 iSCSI driver.
  *
- * Copyright (c) 2010 Chelsio Communications, Inc.
+ * Copyright (c) 2010-2015 Chelsio Communications, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index 42c9284..f4cfa1e 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -1,7 +1,7 @@
 /*
  * libcxgbi.c: Chelsio common library for T3/T4 iSCSI driver.
  *
- * Copyright (c) 2010 Chelsio Communications, Inc.
+ * Copyright (c) 2010-2015 Chelsio Communications, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index ecac554..f628dce 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -1,7 +1,7 @@
 /*
  * libcxgbi.h: Chelsio common library for T3/T4 iSCSI driver.
  *
- * Copyright (c) 2010 Chelsio Communications, Inc.
+ * Copyright (c) 2010-2015 Chelsio Communications, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
