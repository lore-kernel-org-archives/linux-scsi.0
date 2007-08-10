From: akpm@linux-foundation.org
Subject: [patch 01/30] bsg: declare request_queue
Date: Fri, 10 Aug 2007 14:50:30 -0700
Message-ID: <200708102150.l7ALoUi8011317@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38367 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145AbXHJVvG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>

include/linux/bsg.h:67: warning: 'struct request_queue' declared inside parameter list
include/linux/bsg.h:67: warning: its scope is only this definition or declaration, which is probably not what you want
include/linux/bsg.h:71: warning: 'struct request_queue' declared inside parameter list

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bsg.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN include/linux/bsg.h~bsg-declare-request_queue include/linux/bsg.h
--- a/include/linux/bsg.h~bsg-declare-request_queue
+++ a/include/linux/bsg.h
@@ -53,6 +53,9 @@ struct sg_io_v4 {
 
 #ifdef __KERNEL__
 
+struct request_queue;
+struct device;
+
 #if defined(CONFIG_BLK_DEV_BSG)
 struct bsg_class_device {
 	struct class_device *class_dev;
_
