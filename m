From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 26/36] aha1542: remove useless changelog
Date: Fri,  6 Feb 2015 23:11:47 +0100
Message-ID: <1423260717-15944-27-git-send-email-linux@rainbow-software.org>
References: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:56969 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbbBFWQF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2015 17:16:05 -0500
Received: from stip-static-68.213-81-217.telecom.sk ([213.81.217.68] helo=gsql.ggedos.sk)
	by gsystem.sk with esmtpsa (TLS1.1:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <linux@rainbow-software.org>)
	id 1YJr8H-0006fF-El
	for linux-scsi@vger.kernel.org; Fri, 06 Feb 2015 23:12:13 +0100
In-Reply-To: <1423260717-15944-1-git-send-email-linux@rainbow-software.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/aha1542.c |   25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 7b06698..214b9f4 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1,28 +1,9 @@
-/* $Id: aha1542.c,v 1.1 1992/07/24 06:27:38 root Exp root $
- *  linux/kernel/aha1542.c
+/*
+ *  Driver for Adaptec AHA-1542 SCSI host adapters
  *
  *  Copyright (C) 1992  Tommy Thorn
  *  Copyright (C) 1993, 1994, 1995 Eric Youngdale
- *
- *  Modified by Eric Youngdale
- *        Use request_irq and request_dma to help prevent unexpected conflicts
- *        Set up on-board DMA controller, such that we do not have to
- *        have the bios enabled to use the aha1542.
- *  Modified by David Gentzel
- *        Don't call request_dma if dma mask is 0 (for BusLogic BT-445S VL-Bus
- *        controller).
- *  Modified by Matti Aarnio
- *        Accept parameters from LILO cmd-line. -- 1-Oct-94
- *  Modified by Mike McLagan <mike.mclagan@linux.org>
- *        Recognise extended mode on AHA1542CP, different bit than 1542CF
- *        1-Jan-97
- *  Modified by Bjorn L. Thordarson and Einar Thor Einarsson
- *        Recognize that DMA0 is valid DMA channel -- 13-Jul-98
- *  Modified by Chris Faulhaber <jedgar@fxp.org>
- *        Added module command-line options
- *        19-Jul-99
- *  Modified by Adam Fritzler
- *        Added proper detection of the AHA-1640 (MCA, now deleted)
+ *  Copyright (C) 2015 Ondrej Zary
  */
 
 #include <linux/module.h>
-- 
Ondrej Zary

