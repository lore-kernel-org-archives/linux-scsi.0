From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 7/8] vhost/scsi: Drop left-over scsi_tcq.h include
Date: Fri,  6 Feb 2015 05:06:40 +0000
Message-ID: <1423199201-14659-8-git-send-email-nab@daterainc.com>
References: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:48324 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777AbbBFFjy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Feb 2015 00:39:54 -0500
Received: by mail-oi0-f53.google.com with SMTP id i138so10263613oig.12
        for <linux-scsi@vger.kernel.org>; Thu, 05 Feb 2015 21:39:53 -0800 (PST)
In-Reply-To: <1423199201-14659-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

With the recent removal of MSG_*_TAG defines in commit 68d81f40,
vhost-scsi is now using TCM_*_TAG and doesn't depend upon host
side scsi_tcq.h definitions anymore.

Cc: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/vhost/scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index b5e2b40..1a66fcf 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -38,7 +38,6 @@
 #include <linux/miscdevice.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
-#include <scsi/scsi_tcq.h>
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 #include <target/target_core_fabric_configfs.h>
-- 
1.9.1

