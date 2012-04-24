From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [v2 PATCH 0/4] bnx2fc version 1.0.11
Date: Tue, 24 Apr 2012 15:26:00 -0700
Message-ID: <1335306364-31449-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4428 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab2DXW0Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Apr 2012 18:26:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

v2 submittal:
Updated "0002-bnx2fc-Decrememnt-io-ref-count-when-abort-times-out"
patch to release the command reference before waiting for the target to
relogin.  Without this, the logout process will not complete and recovery
fails.
---------------

James, please consider merging the following bug fixes for 3.5.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (4):
  bnx2fc: Allow FLOGI to be retried when receiving bad responses.
  bnx2fc: Decrememnt io ref count when abort times out
  bnx2fc: cleanup task management IO when it times out.
  Bumped version to 1.0.11

 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_els.c  |   16 +----
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  122 +++++++++++++++++++++++--------------
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |   21 ++++++-
 5 files changed, 100 insertions(+), 63 deletions(-)


