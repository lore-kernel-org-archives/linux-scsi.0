From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] iscsi_tcp: Remove unused field iscsi_conn from struct iscsi_sw_tcp_conn
Date: Fri,  9 Apr 2010 22:07:39 -0500
Message-ID: <1270868859-5147-5-git-send-email-michaelc@cs.wisc.edu>
References: <1270868859-5147-1-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-2-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-3-git-send-email-michaelc@cs.wisc.edu>
 <1270868859-5147-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903Ab0DJDIC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 23:08:02 -0400
In-Reply-To: <1270868859-5147-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Avi Kaplan <savik751@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Avi Kaplan <savik751@gmail.com>

iscsi_conn is not used so remove it from iscsi_sw_tcp_conn.

Signed-off-by: Avi Kaplan <savik751@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index ca6b7bc..94644ba 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -36,7 +36,6 @@ struct iscsi_sw_tcp_send {
 };
 
 struct iscsi_sw_tcp_conn {
-	struct iscsi_conn	*iscsi_conn;
 	struct socket		*sock;
 
 	struct iscsi_sw_tcp_send out;
-- 
1.6.6.1

