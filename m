From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND v2 0/9] bnx2fc: Version 1.0.4
Date: Wed, 27 Jul 2011 11:32:04 -0700
Message-ID: <1311791533-27745-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2474 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab1G0Sc0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 14:32:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Resubmitting after resolving compilation failure in "bnx2fc: Support 'sequence
cleanup' task" patch.  Submitting from this patch since previous patches were
accepted.

Compiled & tested individual patches.

Bhanu Prakash Gollapudi (9):
  bnx2fc: Support 'sequence cleanup' task
  bnx2fc: REC/SRR link service request and response handling
  bnx2fc: Handle REC_TOV error code from firmware
  bnx2fc: HSI changes for tape
  bnx2fc: Enable support for sequence level error recovery
  bnx2fc: hold tgt lock when calling cmd_release
  bnx2fc: Do not arm CQ when there are no CQEs
  bnx2fc: Tx BDs cache in write tasks
  bnx2fc: Update copyright and bump version to 1.0.4

 drivers/scsi/bnx2fc/bnx2fc.h      |   31 +++-
 drivers/scsi/bnx2fc/bnx2fc_els.c  |  417 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    7 +-
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  304 +++++++++++++++++++++++----
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  119 ++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    2 +-
 6 files changed, 821 insertions(+), 59 deletions(-)


