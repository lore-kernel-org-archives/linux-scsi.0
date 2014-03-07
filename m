From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH 0/2] bnx2fc: fix memory leak and potential NULL pointer dereferences
Date: Fri,  7 Mar 2014 15:37:44 +0100
Message-ID: <1394203066-13515-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbaCGOiG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Mar 2014 09:38:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: eddie.wai@broadcom.com
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com, m.lombardi85@gmail.com

The first patch removes a unused variable from the bnx2fc_free_hash_table() function,
it was already posted on the linux-scsi mailing list:

http://www.spinics.net/lists/linux-scsi/msg72740.html

but has not been picked up yet.

The second patch fixes a memory leak and some NULL pointer dereferences
that may happen if bnx2fc_allocate_hash_table() fails.

Maurizio Lombardi (2):
  bnx2fc: remove unused variable hash_table_size
  bnx2fc: fix memory leak and potential NULL pointer dereference.

 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

-- 
Maurizio Lombardi

