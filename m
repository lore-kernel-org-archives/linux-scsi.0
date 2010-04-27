From: akpm@linux-foundation.org
Subject: [patch 01/28] scsi: add __init/__exit macros to ibmvstgt.c
Date: Tue, 27 Apr 2010 14:22:47 -0700
Message-ID: <201004272122.o3RLMmfS020772@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977Ab0D0VXQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, peterhuewe@gmx.de, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au

From: Peter Huewe <peterhuewe@gmx.de>

Add the __init and __exit macros to the module_init / module_exit
functions from drivers/scsi/ibmvscsi/ibmvstgt.c

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmvscsi/ibmvstgt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc drivers/scsi/ibmvscsi/ibmvstgt.c
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc
+++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -956,7 +956,7 @@ static struct srp_function_template ibmv
 	.it_nexus_response = ibmvstgt_it_nexus_response,
 };
 
-static int ibmvstgt_init(void)
+static int __init ibmvstgt_init(void)
 {
 	int err = -ENOMEM;
 
@@ -987,7 +987,7 @@ release_transport:
 	return err;
 }
 
-static void ibmvstgt_exit(void)
+static void __exit ibmvstgt_exit(void)
 {
 	printk("Unregister IBM virtual SCSI driver\n");
 
_
