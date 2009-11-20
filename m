From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH] fcoe patch for scsi-post-merge.git (2.6.33)
Date: Fri, 20 Nov 2009 15:22:15 -0800
Message-ID: <20091120232215.3449.44917.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:17523 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZKTXWJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 18:22:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series adds fcoe stack support for a new netdev API that allows an Ethernet
driver to specify a WWNN and WWPN for its FCoE connection.

This patch depends on the netdev_ops.ndo_fcoe_get_wwn() API, which is currently in
net-next-2.6.git. To apply this patch net-next-2.6.git should be merged into scsi-misc.git
(after the 9 previously submitted fcoe patches on 11/20/09 are committed to scsi-misc.git).

---

Yi Zou (1):
      fcoe: Use LLD's WWPN and WWNN for lport if LLD supports ndo_fcoe_get_wwn


 drivers/scsi/fcoe/fcoe.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

-- 
//Rob
