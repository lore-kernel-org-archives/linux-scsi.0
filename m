From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/3] BNX2I: Bug fixes and Performance Optimization
Date: Mon, 16 May 2011 11:13:17 -0700
Message-ID: <1305569600-1523-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2869 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab1EPSNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 14:13:31 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

This patch set contains a bug fix and some performance optimization
for iSCSI offload connection cleanup/recovery and throughput.

Please review, thanks.

Eddie Wai (3):
  BNX2I: Fixed packet error created when the sq_size is set to 16
  BNX2I: Updated the connection shutdown/cleanup timeout
  BNX2I: Optimized the iSCSI offload performance

 drivers/scsi/bnx2i/bnx2i.h       |   16 ++++++++++------
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   27 +++++++++++++++------------
 drivers/scsi/bnx2i/bnx2i_init.c  |    2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   13 +++++++++++--
 4 files changed, 37 insertions(+), 21 deletions(-)


