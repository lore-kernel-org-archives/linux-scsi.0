From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/5 v2] Patch set to fix various bugs in bnx2i
Date: Thu, 12 Aug 2010 16:44:26 -0700
Message-ID: <1281656671-5369-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2877 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761132Ab0HLXmy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Aug 2010 19:42:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

The first 2 patches fix issues related to rfc3720 for nopout and TMF.
The last 2 patches fix issues related to Broadcom specific cleanup
under different situations.

Please review, thanks.
Eddie

Eddie Wai (5):
  BNX2I: Fixed a protocol violation on nopout responses
  BNX2I: Added support for other TMFs besides ABORT_TASK
  BNX2I: Recouple the CFC delete cleanup with cm_abort/close completion
  BNX2I: Added chip cleanup for the remove module path
  BNX2I: Updated version to bnx2i-2.1.3

 drivers/scsi/bnx2i/bnx2i.h       |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c   |   64 +++++++++++++++++++------------------
 drivers/scsi/bnx2i/bnx2i_init.c  |   62 +++++++++++++++++++++++-------------
 drivers/scsi/bnx2i/bnx2i_iscsi.c |   15 +++++---
 4 files changed, 82 insertions(+), 61 deletions(-)


