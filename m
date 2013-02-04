From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] [SCSI] fnic: Remove unneeded version.h header file include
Date: Mon,  4 Feb 2013 13:45:17 +0530
Message-ID: <1359965717-2615-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f52.google.com ([209.85.210.52]:48990 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3BDIYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2013 03:24:36 -0500
Received: by mail-da0-f52.google.com with SMTP id f10so2541534dak.25
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2013 00:24:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hiralpat@cisco.com, JBottomley@parallels.com, sramars@cisco.com, buchino@cisco.com, sachin.kamat@linaro.org

version.h header file inclusion is not necessary.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/scsi/fnic/fnic_trace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_trace.c b/drivers/scsi/fnic/fnic_trace.c
index 0b18bf4..63f6f5b 100644
--- a/drivers/scsi/fnic/fnic_trace.c
+++ b/drivers/scsi/fnic/fnic_trace.c
@@ -19,7 +19,6 @@
 #include <linux/mempool.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
-#include <linux/version.h>
 #include <linux/kallsyms.h>
 #include "fnic_io.h"
 #include "fnic.h"
-- 
1.7.4.1

