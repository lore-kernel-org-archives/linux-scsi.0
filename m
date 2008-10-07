From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 08/12] i5k_amb: Load automatically on all 5000/5400 chipsets
Date: Mon, 06 Oct 2008 18:19:04 -0700
Message-ID: <20081007011904.12701.37660.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52190 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbYJGBTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2008 21:19:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e8.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id m971GN81010500
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:16:23 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971J5wQ273782
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:05 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971J58w010493
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:05 -0400
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/i5k_amb.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 2ede938..bf153ae 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -605,3 +605,6 @@ MODULE_LICENSE("GPL");
 
 module_init(i5k_amb_init);
 module_exit(i5k_amb_exit);
+
+MODULE_ALIAS("pci:v00008086d000025F0sv*sd*bc*sc*i*");
+MODULE_ALIAS("pci:v00008086d00004030sv*sd*bc*sc*i*");

