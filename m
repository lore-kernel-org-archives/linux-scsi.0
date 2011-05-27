From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: Fwd: [Open-FCoE] [PATCH 4/4] bnx2fc: Bumped version to 1.0.2
Date: Thu, 26 May 2011 22:22:55 -0700
Message-ID: <4DDF352F.2020800@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4780 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1E0FXI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 01:23:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi James,

It doesnt look like the following patch set was committed. Can you 
please do so? Please let me know if you want me to re-submit.

Here are the links:

http://marc.info/?l=linux-scsi&m=130135398425844&w=2
http://marc.info/?l=linux-scsi&m=130135398825857&w=2
http://marc.info/?l=linux-scsi&m=130135399825872&w=2
http://marc.info/?l=linux-scsi&m=130135401925893&w=2


Thanks,
Bhanu

-------- Original Message --------
Subject: [Open-FCoE] [PATCH 4/4] bnx2fc: Bumped version to 1.0.2
Date: Mon, 28 Mar 2011 16:12:57 -0700
From: Bhanu Gollapudi <bprakash@broadcom.com>
To: James.Bottomley@suse.de <James.Bottomley@suse.de>
CC: devel@open-fcoe.org <devel@open-fcoe.org>, 
linux-scsi@vger.kernel.org	<linux-scsi@vger.kernel.org>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
  drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
  drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
  2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index e9cfda3..24102e8 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -62,7 +62,7 @@
  #include "bnx2fc_constants.h"

  #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.1"
+#define BNX2FC_VERSION		"1.0.2"

  #define PFX			"bnx2fc: "

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c 
b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 41456c5..8fb9b6e 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -21,7 +21,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);

  #define DRV_MODULE_NAME		"bnx2fc"
  #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Mar 17, 2011"
+#define DRV_MODULE_RELDATE	"Mar 28, 2011"


  static char version[] __devinitdata =
-- 
1.7.0.6




_______________________________________________
devel mailing list
devel@open-fcoe.org
https://lists.open-fcoe.org/mailman/listinfo/devel


