From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/5] bnx2fc version 1.0.14
Date: Fri, 8 Mar 2013 13:28:49 -0800
Message-ID: <1362778134-21045-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1626 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3CHV3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Mar 2013 16:29:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Hi James,

Please consider including the following patches for 3.9+ merge window.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (5):
  bnx2fc: Enable cached tasks to improve performance
  bnx2fc: Include chip number in the symbolic name
  bnx2fc: Fix race condition between IO completion and abort
  bnx2fc: Update copyright information
  bnx2fc: Bumped version to 1.0.14

 drivers/scsi/bnx2fc/bnx2fc.h      |   57 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_els.c  |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   55 ++++++++++++++++++++++++++++++-----
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |    8 ++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    9 ++++--
 drivers/scsi/bnx2fc/bnx2fc_tgt.c  |    2 +-
 6 files changed, 116 insertions(+), 17 deletions(-)


