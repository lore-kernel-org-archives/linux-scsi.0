From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 0/4] bnx2fc version 1.0.8
Date: Mon, 3 Oct 2011 16:44:59 -0700
Message-ID: <1317685503-22622-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1184 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab1JCXpY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 19:45:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

James, 

Can you please apply these patches to scsi-misc tree targetting 3.2?

Please note that patch 3 (bnx2fc: Return error statistics of remote peer)
depends on patch 2 (fcoe/libfcoe: Move common code for fcoe_get_lesb to
fcoe_transport).

Thanks,
Bhanu

Bhanu Prakash Gollapudi (4):
  bnx2fc: call ctlr_link_up only when the interface is enabled
  fcoe/libfcoe: Move common code for fcoe_get_lesb to fcoe_transport
  bnx2fc: Return error statistics of remote peer
  bnx2fc: Bumped version to 1.0.8

 drivers/scsi/bnx2fc/bnx2fc.h       |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c  |   24 +++++++++++++++++++++++-
 drivers/scsi/fcoe/fcoe.c           |   21 +--------------------
 drivers/scsi/fcoe/fcoe_transport.c |   29 +++++++++++++++++++++++++++++
 include/scsi/libfcoe.h             |    2 ++
 5 files changed, 56 insertions(+), 22 deletions(-)


