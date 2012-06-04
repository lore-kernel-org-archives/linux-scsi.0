From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/6] bnx2fc version 1.0.12
Date: Mon, 4 Jun 2012 16:15:41 -0700
Message-ID: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3056 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761178Ab2FDXP4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2012 19:15:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

James,

Please consider including the following patches in the 3.5+ merge window.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (4):
  bnx2fc: Support interface creation on non-VLAN interface also.
  bnx2fc: Improve error recovery by handling parity errors
  bnx2fc: use list_entry instead of explicit cast
  bnx2fc: Bumped version to 1.0.12

Eric Dumazet (1):
  bnx2fc: use kthread_create_on_node

Joe Perches (1):
  bnx2fc: Reduce object size by consolidating formats

 drivers/scsi/bnx2fc/Makefile       |    3 +-
 drivers/scsi/bnx2fc/bnx2fc.h       |    9 +++-
 drivers/scsi/bnx2fc/bnx2fc_debug.c |   70 ++++++++++++++++++++++++++++++++++
 drivers/scsi/bnx2fc/bnx2fc_debug.h |   73 +++++++++---------------------------
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |   46 +++++++++++------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c   |    4 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c    |   21 +++-------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c   |   39 ++++++++++++-------
 8 files changed, 153 insertions(+), 112 deletions(-)
 create mode 100644 drivers/scsi/bnx2fc/bnx2fc_debug.c


