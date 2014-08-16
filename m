From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] fusion: fix excess parameter kernel-doc warning
Date: Sat, 16 Aug 2014 14:15:15 -0700
Message-ID: <53EFC9E3.6070306@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40296 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaHPVPQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Aug 2014 17:15:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, DL-MPTFusionLinux@lsi.com, MPT-FusionLinux.pdl@avagotech.com

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc excess parameter warning:

Warning(..//drivers/message/fusion/mptbase.c:1411): Excess function parameter 'prod_name' description in 'mpt_get_product_name'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: DL-MPTFusionLinux@lsi.com
Cc: MPT-FusionLinux.pdl@avagotech.com
---
 drivers/message/fusion/mptbase.c |    1 -
 1 file changed, 1 deletion(-)

Index: lnx-317-rc1/drivers/message/fusion/mptbase.c
===================================================================
--- lnx-317-rc1.orig/drivers/message/fusion/mptbase.c
+++ lnx-317-rc1/drivers/message/fusion/mptbase.c
@@ -1400,7 +1400,6 @@ mpt_verify_adapter(int iocid, MPT_ADAPTE
  *	@vendor: pci vendor id
  *	@device: pci device id
  *	@revision: pci revision id
- *	@prod_name: string returned
  *
  *	Returns product string displayed when driver loads,
  *	in /proc/mpt/summary and /sysfs/class/scsi_host/host<X>/version_product
