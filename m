From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/4] bnx2fc version 1.0.10
Date: Mon, 23 Jan 2012 18:00:45 -0800
Message-ID: <1327370449-28168-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2205 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755457Ab2AXCBD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2012 21:01:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, mchan@broadcom.com

James,

Please include the following bug fixes in the next merge window.

Thanks,
Bhanu

Bhanu Prakash Gollapudi (4):
  bnx2fc: fix panic in bnx2fc_post_io_req
  bnx2fc: Handle LOGO flooding from the target
  bnx2fc: NPIV ports go offline when interface is brought down & up
  bnx2fc: Bumped version to 1.0.10

 drivers/scsi/bnx2fc/bnx2fc.h      |    8 ++++++--
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |   20 ++++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)


