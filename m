From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH] Added fix for unsolicited NOP-In handling
Date: Wed, 21 Jul 2010 11:51:09 -0700
Message-ID: <1279738270-21911-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1143 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0GUSty (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 14:49:54 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

Two unsolicited NOP-In fixes are included in this patch set:
1 - ITT bug fix for the unsolicited NOP-In handling
2 - added the RQE extraction even when the rx pipe is suspended

Your comments are greatly appreciated.  Please review, thanks.
Eddie

Eddie Wai (1):
  BNX2I: Fixed bugs in the handling of unsolicited NOP-Ins

 drivers/scsi/bnx2i/bnx2i_hwi.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)


