From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] label needs statement following it
Date: Wed, 27 Aug 2003 22:07:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030827220710.1c118a55.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:38309 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261458AbTH1FJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2003 01:09:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@steeleye.com, support@compaq.com


Hi,
Please apply.

patch_name:	cpqfc_labelend.patch
patch_version:	2003-08-27.18:19:34
author:		Randy.Dunlap <rddunlap@osdl.org>
description:	cpqfc: label needs a (empty) statement after it;
product:	Linux
product_versions: 260-test4
maintainer:	support@compaq.com

diff -Naur ./drivers/scsi/cpqfcTSworker.c~labelend ./drivers/scsi/cpqfcTSworker.c
--- ./drivers/scsi/cpqfcTSworker.c~labelend	Fri Aug 22 16:58:39 2003
+++ ./drivers/scsi/cpqfcTSworker.c	Wed Aug 27 12:27:09 2003
@@ -2878,7 +2878,7 @@
     }
   }
 
-Done:  
+Done: ;
 }
 
 extern int is_private_data_of_cpqfc(CPQFCHBA *hba, void * pointer);


--
~Randy
