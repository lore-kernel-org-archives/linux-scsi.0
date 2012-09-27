From: Robert Love <robert.w.love@intel.com>
Subject: [RFC PATCH v2 1/5] fix_section_mismatch
Date: Wed, 26 Sep 2012 19:01:48 -0700
Message-ID: <20120927020148.20592.17054.stgit@fritz>
References: <20120927020142.20592.56661.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44412 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab2I0CBt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2012 22:01:49 -0400
In-Reply-To: <20120927020142.20592.56661.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, bvanassche@acm.org, bprakash@broadcom.com
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

Already fixed upstream.
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b46f43d..71cc909 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
 	return 0;
 }
 
-static int __exit fcoe_transport_exit(void)
+static int fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 

