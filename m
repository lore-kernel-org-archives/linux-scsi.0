From: Doug Maxey <dwm@enoyolf.org>
Subject: Re: [RFC] [PATCH 1/7] requested for qla4xxx!!!
Date: Thu, 29 Jun 2006 15:20:17 -0500
Message-ID: <20060629202017.103393@bebe.enoyolf.org>
References: <20060628042436.274455@bebe.enoyolf.org> <44A2C187.8030801@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from falcon30.maxeymade.com ([24.173.215.190]:55500 "EHLO
	bebe.enoyolf.org") by vger.kernel.org with ESMTP id S932376AbWF2UU3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jun 2006 16:20:29 -0400
In-reply-to: <20060629064924.GB7220@ranandlinuxbox.oc.cox.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, open-iscsi <open-iscsi@googlegroups.com>


On Wed, 28 Jun 2006 23:49:24 PDT, Ravi Anand wrote:
> ISP4xxx driver definitions.

I missed a #include in ql4_def.h.

>From 655dd4a50f40edbbd48f02fc8cfa5c79d451e10d Mon Sep 17 00:00:00 2001
From: Doug Maxey <dwm@enoyolf.org>
Date: Thu, 29 Jun 2006 15:16:52 -0500
Subject: [PATCH] qla4xxx: remove deprecated #include

Remove the #include ql4_netlnk.h as the file no longer exists.
Should build now. :)

Signed-off-by: Doug Maxey <dwm@enoyolf.org>
---
 drivers/scsi/qla4xxx/ql4_def.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 7e7dc1f..876875b 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -614,6 +614,5 @@ #include "ql4_version.h"
 #include "ql4_glbl.h"
 #include "ql4_dbg.h"
 #include "ql4_inline.h"
-#include "ql4_netlnk.h"
 
 #endif	/*_QLA4XXX_H */
-- 
1.4.0



