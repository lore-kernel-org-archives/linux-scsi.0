From: madhu.iyengar@qlogic.com
Subject: [PATCH 0/1] Update for scsi-misc-2.6
Date: Tue,  7 Sep 2010 20:55:31 -0700
Message-ID: <1283918132-9521-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:49268 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1750777Ab0IHEA7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Sep 2010 00:00:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

We missed this patch a few days ago. Can you please include this.

Thanks.

Shyam Sundar (1):
  qla2xxx: ROM lock recovery if fw hangs while holding the lock.

 drivers/scsi/qla2xxx/qla_nx.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 files changed, 36 insertions(+), 3 deletions(-)

