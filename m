From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe patch fix for 3.3 (scsi-misc)
Date: Fri, 16 Dec 2011 14:24:44 -0800
Message-ID: <20111216222444.24177.32377.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab1LPWYp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 17:24:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is just a trivial patch that I wanted to get out before the holidays.

---

Robert Love (1):
      fcoe: remove double check if skb is nonlinear


 drivers/scsi/fcoe/fcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

-- 
Thanks, //Rob
