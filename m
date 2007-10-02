From: akpm@linux-foundation.org
Subject: [patch 09/17] add includes to scsi_transport_iscsi.h
Date: Tue, 02 Oct 2007 14:38:05 -0700
Message-ID: <200710022138.l92Lc5NQ023582@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755590AbXJBViZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, mst@dev.mellanox.co.il, michaelc@cs.wisc.edu, rdreier@cisco.com

From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>

scsi/scsi_transport_iscsi.h uses struct mutex and struct list_head,
so while linux/mutex.h and linux/list.h seem to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h and linus/list.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_transport_iscsi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/scsi/scsi_transport_iscsi.h~add-includes-to-scsi_transport_iscsih include/scsi/scsi_transport_iscsi.h
--- a/include/scsi/scsi_transport_iscsi.h~add-includes-to-scsi_transport_iscsih
+++ a/include/scsi/scsi_transport_iscsi.h
@@ -24,6 +24,8 @@
 #define SCSI_TRANSPORT_ISCSI_H
 
 #include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;
_
