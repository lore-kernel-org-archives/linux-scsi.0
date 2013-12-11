From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] hpsa: bump driver version to 3.4.2-1
Date: Wed, 11 Dec 2013 12:55:33 -0600
Message-ID: <20131211185533.GB11427@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com, mike.miller@hp.com
List-Id: linux-scsi@vger.kernel.org

From: Mike Miller <mike.miller@hp.com>

Bump the driver version so we can tell appoximately where it lines up with our
internal svn repository.

Signe-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8a27d7b..4f7589d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -54,7 +54,7 @@
 #include "hpsa.h"
 
 /* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */
-#define HPSA_DRIVER_VERSION "3.4.0-1"
+#define HPSA_DRIVER_VERSION "3.4.2-5"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
