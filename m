From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [v2 PATCH 0/3] bnx2fc version 1.0.12
Date: Thu, 7 Jun 2012 02:19:34 -0700
Message-ID: <1339060777-10972-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1436 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760391Ab2FGJTt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jun 2012 05:19:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

v2 submittal: Fixed compilation error when compiling individual patches
seperately. Since the first three patches in the v1 patchset were accepted,
submitting remaining three patches.
------------------

James,

Please consider including the following patches in the 3.5+ merge window.

Thanks,
Bhanu


Bhanu Prakash Gollapudi (3):
  bnx2fc: Improve error recovery by handling parity errors
  bnx2fc: use list_entry instead of explicit cast
  bnx2fc: Bumped version to 1.0.12

 drivers/scsi/bnx2fc/bnx2fc.h      |    3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    7 +----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    4 ++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |   21 ++++++-------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   40 +++++++++++++++++++++++-------------
 5 files changed, 39 insertions(+), 36 deletions(-)


