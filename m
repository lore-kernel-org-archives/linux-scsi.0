From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] hpsa: Smart Array Gen8 marketing names
Date: Thu, 20 Sep 2012 16:08:04 -0500
Message-ID: <20120920210804.GB30921@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:16683 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2ITVIK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2012 17:08:10 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com


hpsa: add marketing names for Gen8 controllers

From: Mike Miller <mike.miller@hp.com>

Now that the controllers have announced I can add the marketing names for
the Proliant Gen8 server controllers.
---
 drivers/scsi/hpsa.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index edc598b..41fc5b0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -127,13 +127,13 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
-	{0x3356103C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array P222", &SA5_access},
+	{0x3351103C, "Smart Array P420", &SA5_access},
+	{0x3352103C, "Smart Array P421", &SA5_access},
+	{0x3353103C, "Smart Array P822", &SA5_access},
+	{0x3354103C, "Smart Array P420i", &SA5_access},
+	{0x3355103C, "Smart Array P220i", &SA5_access},
+	{0x3356103C, "Smart Array P721m", &SA5_access},
 	{0x1920103C, "Smart Array", &SA5_access},
 	{0x1921103C, "Smart Array", &SA5_access},
 	{0x1922103C, "Smart Array", &SA5_access},
@@ -142,7 +142,7 @@ static struct board_type products[] = {
 	{0x1925103C, "Smart Array", &SA5_access},
 	{0x1926103C, "Smart Array", &SA5_access},
 	{0x1928103C, "Smart Array", &SA5_access},
-	{0x334d103C, "Smart Array", &SA5_access},
+	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
