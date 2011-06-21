From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/4] BNX2I: Code and performance optimization
Date: Tue, 21 Jun 2011 09:49:50 -0700
Message-ID: <1308674994-4694-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2841 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab1FUQuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2011 12:50:14 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

This patch set contains a collection of code and performance optimization
changes.

Your comments are welcome.  Please review.

Eddie

Eddie Wai (4):
  BNX2I: Added the use of kthreads to handle SCSI cmd completion
  BNX2I: Modified to skip CNIC registration if iSCSI is not supported
  BNX2I: Changed the nopout_wqe->lun memcpy to use sizeof instead
  BNX2I: Updated copyright and bump version

 drivers/scsi/bnx2i/57xx_iscsi_constants.h |    2 +-
 drivers/scsi/bnx2i/57xx_iscsi_hsi.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i.h                |   35 +++++-
 drivers/scsi/bnx2i/bnx2i_hwi.c            |  188 ++++++++++++++++++++++++-----
 drivers/scsi/bnx2i/bnx2i_init.c           |  153 +++++++++++++++++++++---
 drivers/scsi/bnx2i/bnx2i_iscsi.c          |   43 ++++++-
 drivers/scsi/bnx2i/bnx2i_sysfs.c          |    2 +-
 7 files changed, 366 insertions(+), 59 deletions(-)


