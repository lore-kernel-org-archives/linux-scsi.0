From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 6/6] scsi tgt: Makefile and Kconfig changes
Date: Tue, 14 Mar 2006 16:58:04 -0500
Message-ID: <44173C6C.1050003@ce.jp.nec.com>
References: <1140119627.20193.55.camel@max>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060208050900010705090605"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:5792 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932513AbWCNV4g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Mar 2006 16:56:36 -0500
In-Reply-To: <1140119627.20193.55.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, fujita.tomonori@lab.ntt.co.jp
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------060208050900010705090605
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello Mike, Fujita-san,

scsi_tgt_if.c depends on CONFIG_NET for using netlink.
So it would be nice if the Kconfig entry checks it.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------060208050900010705090605
Content-Type: text/x-patch;
 name="scsi_tgt_kconf.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_tgt_kconf.patch"

--- linux-2.6.16-rc6-mm1.orig/drivers/scsi/Kconfig	2006-03-14 09:52:19.000000000 -0500
+++ linux-2.6.16-rc6-mm1/drivers/scsi/Kconfig	2006-03-14 15:56:32.000000000 -0500
@@ -29,7 +29,7 @@ config SCSI
 
 config SCSI_TGT
 	tristate "SCSI target support"
-	depends on SCSI && EXPERIMENTAL
+	depends on SCSI && NET && EXPERIMENTAL
 	---help---
 	  If you want to use SCSI target mode drivers enable this option.
 	  If you choose M, the module will be called scsi_tgt.

--------------060208050900010705090605--
