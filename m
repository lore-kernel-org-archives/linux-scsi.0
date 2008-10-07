From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 01/12] hwmon: Define sysfs interface for energy consumption
	register.
Date: Mon, 06 Oct 2008 18:18:29 -0700
Message-ID: <20081007011829.12701.29034.stgit@elm3a70.beaverton.ibm.com>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:35623 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYJGBSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Oct 2008 21:18:32 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m971IVE2008297
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 21:18:31 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m971IVtd188424
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:18:31 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m971I1Ll008887
	for <linux-scsi@vger.kernel.org>; Mon, 6 Oct 2008 19:18:01 -0600
In-Reply-To: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>


Describe the sysfs files that were introduced in the ibmaem driver.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/sysfs-interface |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index 2d84573..6d47cb2 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -321,6 +321,14 @@ curr[1-*]_input	Current input value
 		Unit: milliampere
 		RO
 
+**********
+* Energy *
+**********
+
+energy[1-*]_input		Cumulative energy use
+				Unit: microJoule
+				RO
+
 *********
 * Power *
 *********
@@ -329,6 +337,10 @@ power[1-*]_average		Average power use
 				Unit: microWatt
 				RO
 
+power[1-*]_average_interval	Power use averaging interval
+				Unit: milliseconds
+				RW
+
 power[1-*]_average_highest	Historical average maximum power use
 				Unit: microWatt
 				RO

