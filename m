From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 24/24] fcoe: Change fcoe receive thread nice value from 19
	(lowest priority) to -20
Date: Fri, 27 Feb 2009 10:56:38 -0800
Message-ID: <20090227185637.25509.59258.stgit@fritz>
References: <20090227185430.25509.34309.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:13744 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152AbZB0S4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:51 -0500
In-Reply-To: <20090227185430.25509.34309.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

This change makes the fcoe Rx threads have the same nice value
as lpfc and qla2xxx Rx threads.

Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 0e0b494..5548bf3 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -531,7 +531,7 @@ int fcoe_percpu_receive_thread(void *arg)
 	struct fcoe_softc *fc;
 	struct fcoe_hdr *hp;
 
-	set_user_nice(current, 19);
+	set_user_nice(current, -20);
 
 	while (!kthread_should_stop()) {
 

