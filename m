From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] qla4xxx: export iface name
Date: Sun, 14 Aug 2011 20:42:56 -0500
Message-ID: <1313372576-2825-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1HOBjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Aug 2011 21:39:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Export the name of iface session is attached to. This is needed
so tools like iscsiadm/iscsistart can match the sessions to
userspace ifaces when rebuilding iscsid's state during boot.

This patch is built over these patches:
http://marc.info/?l=linux-scsi&m=131161955801957&w=2
http://marc.info/?l=linux-scsi&m=131219494805315&w=2
http://marc.info/?l=linux-scsi&m=131314328021458&w=2
so it is for the 3.2 feature window.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 456cd6f..ce391d5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -213,6 +213,7 @@ static mode_t ql4_attr_is_visible(int param_type, int param)
 		case ISCSI_PARAM_FIRST_BURST:
 		case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		case ISCSI_PARAM_IFACE_NAME:
 			return S_IRUGO;
 		default:
 			return 0;
-- 
1.7.6

