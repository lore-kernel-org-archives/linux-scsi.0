From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: [PATCH 085/199] Documentation/scsi/53c700.txt: Checkpatch cleanup
Date: Sun, 23 May 2010 21:53:49 +0200
Message-ID: <1274644435-24421-1-git-send-email-andrea.gelmini@gelma.net>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: andrea.gelmini@gelma.net
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Documentation/scsi/53c700.txt:100: ERROR: trailing whitespace

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
---
 Documentation/scsi/53c700.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scsi/53c700.txt b/Documentation/scsi/53c700.txt
index 0da681d..5b40810 100644
--- a/Documentation/scsi/53c700.txt
+++ b/Documentation/scsi/53c700.txt
@@ -97,7 +97,7 @@ interrupt.
 Handling Interrupts
 -------------------
 
-In general, you should just plumb the card's interrupt line in with 
+In general, you should just plumb the card's interrupt line in with
 
 request_irq(irq, NCR_700_intr, <irq flags>, <driver name>, host);
 
-- 
1.7.1.251.gf80a2

