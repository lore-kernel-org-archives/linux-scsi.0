From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: [PATCH 28/44] includecheck fix: drivers/scsi, ibmvscsi.c
Date: Wed, 08 Jul 2009 21:00:16 +0530
Message-ID: <1247067016.4382.78.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:53164 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbZGHQEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2009 12:04:01 -0400
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, scsi <linux-scsi@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>


fix the following 'make includecheck' warning:

  drivers/scsi/ibmvscsi/ibmvscsi.c: asm/firmware.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 9928704..d9b0e9d 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -73,7 +73,6 @@
 #include <linux/of.h>
 #include <asm/firmware.h>
 #include <asm/vio.h>
-#include <asm/firmware.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
-- 
1.6.0.6



