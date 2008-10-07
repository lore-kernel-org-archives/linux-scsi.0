From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 06/12] adt7470: Load automatically on IntelliStation Z30 via
	DMI
Date: Mon, 06 Oct 2008 18:18:54 -0700
Message-ID: <20081007011854.12701.39465.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:37031 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYJGBT0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:19:26 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971JQFV009889
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:19:26 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971JPR9188476
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:25 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971JP6a012245
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:19:25 -0600
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/hwmon/adt7470.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 656bf3d..ef26014 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1114,3 +1114,6 @@ MODULE_LICENSE("GPL");
 
 module_init(adt7470_init);
 module_exit(adt7470_exit);
+
+MODULE_ALIAS("dmi:bvnIBM:*:rn9228:*");
+MODULE_ALIAS("dmi:bvnIBM:*:rn9232:*");

