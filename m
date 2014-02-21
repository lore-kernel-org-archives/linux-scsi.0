From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/6] hpsa: remove unused kthread.h header
Date: Fri, 21 Feb 2014 16:24:54 -0600
Message-ID: <20140221222454.31344.580.stgit@beardog.cce.hp.com>
References: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:48944 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaBUW00 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 17:26:26 -0500
Received: from g2t2353.austin.hp.com (g2t2353.austin.hp.com [15.217.128.52])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 5548961386
	for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 22:26:26 +0000 (UTC)
In-Reply-To: <20140221222153.31344.99129.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9f593b9..cb984c2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -47,7 +47,6 @@
 #include <linux/string.h>
 #include <linux/bitmap.h>
 #include <linux/atomic.h>
-#include <linux/kthread.h>
 #include <linux/jiffies.h>
 #include <asm/div64.h>
 #include "hpsa_cmd.h"

