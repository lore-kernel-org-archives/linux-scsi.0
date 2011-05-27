From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [RESUBMIT PATCH 0/4] Resubmitting bnx2fc 1.0.2 with merge
 conflicts resolved
Date: Fri, 27 May 2011 11:47:24 -0700
Message-ID: <1306522048-23893-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1668 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1E0Srk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 14:47:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Bhanu Prakash Gollapudi (4):
  bnx2fc: host stats show the link speed 'unknown' on NIC partitioned
    interfaces
  bnx2fc: scsi_dma_unmap() not invoked on IO completions
  bnx2fc: Fix kernel panic when deleting NPIV ports
  bnx2fc: Bumped version to 1.0.2

 drivers/scsi/bnx2fc/bnx2fc.h      |   10 ++++++++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   33 +++++++++++++++++++++++++++++++--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c  |   24 +++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |    2 +-
 4 files changed, 69 insertions(+), 6 deletions(-)


