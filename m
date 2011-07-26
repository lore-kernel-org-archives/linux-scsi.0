From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 00/11] bnx2fc: Version 1.0.4
Date: Tue, 26 Jul 2011 14:51:38 -0700
Message-ID: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2811 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab1GZVwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

James,

Resubmitting the patchset from patch 2 after merging with linux-next tree.

Thanks,
Bhanu

The following patch set contains
        - the support for FCP-2 sequence level error recovery (patch 2-7)
        - the support to handle vlan id changes in the switch (patch 1)
        - enhancements/bug fixes (patch 8,9,10)

Please note that this patchset has dependency on the latest bnx2x and cnic
drivers currently in linux-next tree. These patches were compiled and tested on
linux-next tree.


Bhanu Prakash Gollapudi (11):
  bnx2fc: Introduce interface structure for each vlan interface
  bnx2fc: Enable REC & CONF support for the session
  bnx2fc: Support 'sequence cleanup' task
  bnx2fc: REC/SRR link service request and response handling
  bnx2fc: Handle REC_TOV error code from firmware
  bnx2fc: HSI changes for tape
  bnx2fc: Enable support for sequence level error recovery
  bnx2fc: hold tgt lock when calling cmd_release
  bnx2fc: Do not arm CQ when there are no CQEs
  bnx2fc: Tx BDs cache in write tasks
  bnx2fc: Update copyright and bump version to 1.0.4

 drivers/scsi/bnx2fc/bnx2fc.h      |  107 ++++---
 drivers/scsi/bnx2fc/bnx2fc_els.c  |  427 +++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  723 +++++++++++++++++--------------------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |  414 +++++++++++++++++-----
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  170 ++++++++--
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   27 +-
 6 files changed, 1313 insertions(+), 555 deletions(-)


