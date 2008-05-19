From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/11] zfcp: Refine trace levels of some recovery related events.
Date: Mon, 19 May 2008 12:17:45 +0200
Message-ID: <20080519101832.709747000@de.ibm.com>
References: <20080519101736.590943000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:56414 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYESKSf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 May 2008 06:18:35 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_refine_trace_levels.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This change better spreads trace levels of recovery related events.
There was an overlap of traces for some recovery triggers and the
processing of recovery actions.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:35:46.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-05-19 11:36:24.000000000 +0200
@@ -696,7 +696,7 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	r->u.thread.total = total;
 	r->u.thread.ready = ready;
 	r->u.thread.running = running;
-	debug_event(adapter->rec_dbf, 5, r, sizeof(*r));
+	debug_event(adapter->rec_dbf, 6, r, sizeof(*r));
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
@@ -823,7 +823,7 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 	r->u.action.status = erp_action->status;
 	r->u.action.step = erp_action->step;
 	r->u.action.fsf_req = (unsigned long)erp_action->fsf_req;
-	debug_event(adapter->rec_dbf, 4, r, sizeof(*r));
+	debug_event(adapter->rec_dbf, 5, r, sizeof(*r));
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 

-- 
