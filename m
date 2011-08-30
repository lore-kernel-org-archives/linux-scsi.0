From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/8] bnx2fc version 1.0.6
Date: Tue, 30 Aug 2011 15:54:46 -0700
Message-ID: <1314744894-24710-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3579 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1H3WzG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2011 18:55:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, nsujir@broadcom.com, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

James,

Although all the below patches are bug fixes, I request you to apply them to
scsi-misc tree (targetting 3.2) as the previous patchset (1.0.5) was submitted
to that tree.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (7):
  bnx2fc: Reset max receive frame size during link up
  bnx2fc: Send solicitation only after vlan discovery is complete
  bnx2fc: No abort issued for REC when it times out
  bnx2fc: Avoid calling bnx2fc_if_destroy with unnecessary locks
  bnx2fc: Fix panic caused because of incorrect errror handling in
    create().
  bnx2fc: Fix FW assert during RSCN stress tests
  bnx2fc: Bumped version to 1.0.6

Nithin Nayak Sujir (1):
  bnx2fc: Validate vlan id in NETDEV_UNREGISTER handler

 drivers/scsi/bnx2fc/bnx2fc.h      |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c  |   26 +++++++++--------
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   54 ++++++++++++++++++++++++-------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    6 +++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    4 +--
 5 files changed, 56 insertions(+), 37 deletions(-)


