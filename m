From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: Why is CONFIG_SCSI_QLA2X_X always enabled?
Date: Thu, 22 Apr 2004 09:28:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040422092853.55d0b011.rddunlap@osdl.org>
References: <4087E95F.5050409@ihateaol.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:23246 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S264468AbUDVQez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 12:34:55 -0400
In-Reply-To: <4087E95F.5050409@ihateaol.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Kieran <kieran@ihateaol.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jejb <james.bottomley@steeleye.com>

On Thu, 22 Apr 2004 16:48:47 +0100 Kieran wrote:

| This has been bugging me for a while.. on pretty much all 2.6 kernel 
| configs I've done, the .config has had CONFIG_SCSI_QLA2XXX=y in it, 
| regardless of whether or not I have any other SCSI stuff compiled in. Is 
| there a reason for this, or is it a bug?

A nuisance or annoyance perhaps.  Here's a patch for it.


// linux-266-rc2
// Make SCSI_QLA2XXX config option changeable/selectable

diffstat:=
 drivers/scsi/qla2xxx/Kconfig |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)


diff -Naurp ./drivers/scsi/qla2xxx/Kconfig~scsi_qla2 ./drivers/scsi/qla2xxx/Kconfig
--- ./drivers/scsi/qla2xxx/Kconfig~scsi_qla2	2004-04-20 15:54:24.000000000 -0700
+++ ./drivers/scsi/qla2xxx/Kconfig	2004-04-22 09:39:03.000000000 -0700
@@ -1,6 +1,5 @@
 config SCSI_QLA2XXX
-	tristate
-	default (SCSI && PCI)
+	tristate "Configure QLogic 21xx/22xx/23xx/63xx host adapters"
 	depends on SCSI && PCI
 
 config SCSI_QLA21XX
