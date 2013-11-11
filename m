From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 2/2] target: Core does not need blkdev.h
Date: Mon, 11 Nov 2013 08:59:18 -0800
Message-ID: <1384189158-19913-3-git-send-email-agrover@redhat.com>
References: <1384189158-19913-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab3KKQ72 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Nov 2013 11:59:28 -0500
In-Reply-To: <1384189158-19913-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

Target core does not depend on the block layer, only backstores that
use the block layer do.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_rd.c        |    1 -
 drivers/target/target_core_stat.c      |    1 -
 drivers/target/target_core_transport.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 131327a..4ffe5f2 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -27,7 +27,6 @@
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
-#include <linux/blkdev.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 9c642e0..632665c 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -32,7 +32,6 @@
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
-#include <linux/blkdev.h>
 #include <linux/configfs.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e0669ac..71f79f6 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -28,7 +28,6 @@
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
-#include <linux/blkdev.h>
 #include <linux/spinlock.h>
 #include <linux/kthread.h>
 #include <linux/in.h>
-- 
1.7.1

