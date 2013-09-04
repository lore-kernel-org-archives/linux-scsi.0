From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/4] hpsa: add HP Smart Array Gen8 names
Date: Wed, 4 Sep 2013 15:08:29 -0500
Message-ID: <20130904200829.GB28147@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Patch 2 of 4

From: Mike Miller <mike.miller@hp.com>

Add the marketing names for HP Smart Array Gen8 controllers. Also removes an
unused ID. Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ee71153..d02bdf0 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -147,14 +147,13 @@ static struct board_type products[] = {
 	{0x3354103C, "Smart Array P420i", &SA5_access},
 	{0x3355103C, "Smart Array P220i", &SA5_access},
 	{0x3356103C, "Smart Array P721m", &SA5_access},
-	{0x1920103C, "Smart Array", &SA5_access},
-	{0x1921103C, "Smart Array", &SA5_access},
-	{0x1922103C, "Smart Array", &SA5_access},
-	{0x1923103C, "Smart Array", &SA5_access},
-	{0x1924103C, "Smart Array", &SA5_access},
-	{0x1925103C, "Smart Array", &SA5_access},
-	{0x1926103C, "Smart Array", &SA5_access},
-	{0x1928103C, "Smart Array", &SA5_access},
+	{0x1921103C, "Smart Array P830i", &SA5_access},
+	{0x1922103C, "Smart Array P430", &SA5_access},
+	{0x1923103C, "Smart Array P431", &SA5_access},
+	{0x1924103C, "Smart Array P830", &SA5_access},
+	{0x1926103C, "Smart Array P731m", &SA5_access},
+	{0x1928103C, "Smart Array P230i", &SA5_access},
+	{0x1929103C, "Smart Array P530", &SA5_access},
 	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0x21BD103C, "Smart Array", &SA5_access},
 	{0x21BE103C, "Smart Array", &SA5_access},
