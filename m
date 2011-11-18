From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe fix for 3.2
Date: Fri, 18 Nov 2011 13:35:51 -0800
Message-ID: <20111118213551.25510.37403.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53993 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab1KRVfv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 16:35:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch is necessary so that SW FCoE packets are assigned to the
correct DCB flow. Without it SW FCoE will not function in a DCB
environment. DCB is the primary technology that FCoE uses for
lossless Ethernet.

---

john fastabend (1):
      fcoe: add DCB notifiers to set skb priority


 drivers/scsi/fcoe/fcoe.c      |  115 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_ctlr.c |    4 +
 include/scsi/libfcoe.h        |    3 +
 3 files changed, 122 insertions(+), 0 deletions(-)

-- 
Thanks, //Rob
