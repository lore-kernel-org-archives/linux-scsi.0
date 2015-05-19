From: <nilesh.javali@qlogic.com>
Subject: [PATCH 0/2] bnx2i: Updates for scsi "misc" branch
Date: Tue, 19 May 2015 05:48:42 -0400
Message-ID: <1432028924-25788-1-git-send-email-nilesh.javali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:11734 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739AbbESKdM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 06:33:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: nilesh.javali@qlogic.com, giridhar.malavali@qlogic.com, QLogic-Storage-Upstream@qlogic.com

From: Nilesh Javali <nilesh.javali@qlogic.com>

The following set of patches are bug fixes for bnx2i driver.
Please apply the following patches to the scsi tree at your earliest convenience.

Nilesh Javali (1):
      bnx2i: Fix call trace while device reset

Tej Parkash (1):
      bnx2i: Fixed firmware assert, during target logout.

 drivers/scsi/bnx2i/bnx2i_iscsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)
