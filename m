From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: arm: cumana_1.c:  Remove unused function
Date: Sat, 20 Dec 2014 17:36:15 +0100
Message-ID: <1419093375-8016-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47839 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaLTQd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Dec 2014 11:33:29 -0500
Received: by mail-wi0-f173.google.com with SMTP id r20so4614661wiv.6
        for <linux-scsi@vger.kernel.org>; Sat, 20 Dec 2014 08:33:27 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Russell King <linux@arm.linux.org.uk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

Remove the function cumanascsi_setup() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/arm/cumana_1.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 8ef810a..7c90d9c 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -38,10 +38,6 @@
 
 #include "../NCR5380.h"
 
-void cumanascsi_setup(char *str, int *ints)
-{
-}
-
 const char *cumanascsi_info(struct Scsi_Host *spnt)
 {
 	return "";
-- 
1.7.10.4

