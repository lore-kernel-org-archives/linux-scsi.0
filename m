From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH v2 0/3] bnx2fc: fix memory leaks and NULL pointer dereferences
Date: Mon, 10 Mar 2014 11:03:16 +0100
Message-ID: <1394445799-8463-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaCJKD1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Mar 2014 06:03:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eddie.wai@broadcom.com
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, m.lombardi85@gmail.com

PATCH 1/3 removes a unused variable from the bnx2fc_free_hash_table() function,
it was already posted on the linux-scsi mailing list:

http://www.spinics.net/lists/linux-scsi/msg72740.html

but has not been picked up yet.

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

