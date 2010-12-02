From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/7] zfcp: Add __init declaration to zfcp_cache_hw_align
Date: Thu, 02 Dec 2010 15:16:18 +0100
Message-ID: <20101202141919.723679177@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:50422 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803Ab0LBOTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:24 -0500
Content-Disposition: inline; filename=710-zfcp-init-annotation.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The function zfcp_cache_hw_align is only called from zfcp_module_init,
so it should be declared with __init as well.

Reviewed-by: Steffen Maier <maier@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-12-02 11:14:03.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-12-02 11:14:05.000000000 +0100
@@ -45,8 +45,8 @@ static char *init_device;
 module_param_named(device, init_device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
-static struct kmem_cache *zfcp_cache_hw_align(const char *name,
-					      unsigned long size)
+static struct kmem_cache * __init zfcp_cache_hw_align(const char *name,
+						      unsigned long size)
 {
 	return kmem_cache_create(name, size, roundup_pow_of_two(size), 0, NULL);
 }

