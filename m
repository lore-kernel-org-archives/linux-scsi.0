From: "Randy.Dunlap" <rddunlap@xenotime.net>
Subject: Re: 2.6.3 CONFIG_SCSI_AIC7 X X X Kconfig bug
Date: Mon, 8 Mar 2004 21:11:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040308211148.08cd89ff.rddunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bianca.affordablehost.com ([216.46.192.8]:3287 "EHLO
	bianca.affordablehost.com") by vger.kernel.org with ESMTP
	id S261568AbUCIFQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2004 00:16:26 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: olh@suse.de, jejb <james.bottomley@steeleye.com>, gibbs@scsiguy.com



Olaf Hering reposted this to lkml today.

Please apply to 2.6.current.

Thanks,
~Randy




Begin forwarded message:

On Mon, Feb 09, Randy.Dunlap wrote:


This one is still not applied.

> 
> product_versions: linux-262-pv
> description:	make Adaptec AIC7xyx drivers depend on SCSI tristate
> 


diffstat:=
 drivers/scsi/aic7xxx/Kconfig.aic79xx |    2 +-
 drivers/scsi/aic7xxx/Kconfig.aic7xxx |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff -Naurp ./drivers/scsi/aic7xxx/Kconfig.aic7xxx~depends ./drivers/scsi/aic7xxx/Kconfig.aic7xxx
--- ./drivers/scsi/aic7xxx/Kconfig.aic7xxx~depends	2004-02-03 19:43:42.000000000 -0800
+++ ./drivers/scsi/aic7xxx/Kconfig.aic7xxx	2004-02-09 09:04:01.000000000 -0800
@@ -4,7 +4,7 @@
 #
 config SCSI_AIC7XXX
 	tristate "Adaptec AIC7xxx Fast -> U160 support (New Driver)"
-	depends on PCI || EISA
+	depends on (PCI || EISA) && SCSI
 	---help---
 	This driver supports all of Adaptec's Fast through Ultra 160 PCI
 	based SCSI controllers as well as the aic7770 based EISA and VLB
diff -Naurp ./drivers/scsi/aic7xxx/Kconfig.aic79xx~depends ./drivers/scsi/aic7xxx/Kconfig.aic79xx
--- ./drivers/scsi/aic7xxx/Kconfig.aic79xx~depends	2004-02-03 19:43:43.000000000 -0800
+++ ./drivers/scsi/aic7xxx/Kconfig.aic79xx	2004-02-09 09:03:52.000000000 -0800
@@ -4,7 +4,7 @@
 #
 config SCSI_AIC79XX
 	tristate "Adaptec AIC79xx U320 support"
-	depends on PCI
+	depends on PCI && SCSI
 	help
 	This driver supports all of Adaptec's Ultra 320 PCI-X
 	based SCSI controllers.
