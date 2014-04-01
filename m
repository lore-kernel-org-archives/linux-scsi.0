From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH v3 0/3] bnx2fc: fix memory leaks and NULL pointer dereferences
Date: Tue,  1 Apr 2014 13:58:19 +0200
Message-ID: <1396353502-30083-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbaDAL6l (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Apr 2014 07:58:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, m.lombardi85@gmail.com, eddie.wai@broadcom.com

PATCH 1/3 removes a unused variable from the bnx2fc_free_hash_table() function,

PATCH 2/3 fixes a memory leak and some NULL pointer dereferences in the bnx2fc_free_hash_table() function
that may happen if bnx2fc_allocate_hash_table() fails.

PATCH 3/3 fixes a memory leak in the bnx2fc_allocate_hash_table() function.

Maurizio Lombardi (3):
  bnx2fc: remove unused variable hash_table_size
  bnx2fc: fix memory leak and potential NULL pointer dereference.
  bnx2fc: fix memory leak in bnx2fc_allocate_hash_table()

 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 64 +++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 27 deletions(-)

-- 
Maurizio Lombardi

