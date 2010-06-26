From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: [PATCH 0/7] BNX2I: Patch set to fix various disconnect
 conditions
Date: Fri, 25 Jun 2010 18:39:25 -0700
Message-ID: <1277516372-469-1-git-send-email-eddie.wai@broadcom.com>
References: <Eddie Wai <eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2903 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263Ab0FZBij (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jun 2010 21:38:39 -0400
In-Reply-To: <Eddie Wai <eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@novell.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>, Eddie Wai <eddie.wai@broadcom.com>

Hello,

This patch set contains various code fixes and optimization which mostly
deals with disconnect and clean up issues.

Your comments are grealy appreciated.  Please review, thanks.

Eddie

Eddie Wai (7):
  BNX2I: Separated the hardware's cleanup procedure from ep_disconnect
  BNX2I: Created an active linklist which holds bnx2i endpoints
  BNX2I: Optimized the bnx2i_stop connection clean up procedure
  BNX2I: Fine tuned conn destroy and context destroy timeout values
  BNX2I: Fixed the TCP graceful termination initiation
  BNX2I: Added host param ISCSI_HOST_PARAM_IPADDRESS
  BNX2I: Updated version from 2.1.1 to 2.1.2

 drivers/scsi/bnx2i/bnx2i.h       |   14 +++
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    4 +
 drivers/scsi/bnx2i/bnx2i_init.c  |   39 ++++++-
 drivers/scsi/bnx2i/bnx2i_iscsi.c |  229 +++++++++++++++++++++++++++++---------
 4 files changed, 226 insertions(+), 60 deletions(-)


