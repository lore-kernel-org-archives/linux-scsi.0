From: Rob Evers <revers@redhat.com>
Subject: [PATCH] iscsi_tcp: add write permission to max_lun
Date: Wed, 15 Aug 2012 07:30:05 -0400
Message-ID: <1345030205-23393-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317Ab2HOLaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 07:30:05 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FBU5D8024925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 07:30:05 -0400
Received: from localhost (dhcp-185-85.bos.redhat.com [10.16.185.85])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q7FBU5FG015433
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 07:30:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add root write permission to iscsi_tcp max_lun parameter

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/iscsi_tcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9220861..e8609a4 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -56,7 +56,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht;
 static struct iscsi_transport iscsi_sw_tcp_transport;
 
 static unsigned int iscsi_max_lun = 512;
-module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
+module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO|S_IWUSR);
 
 static int iscsi_sw_tcp_dbg;
 module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
-- 
1.7.1

