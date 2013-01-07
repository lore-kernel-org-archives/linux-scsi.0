From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: update version number to 3.2.0
Date: Mon, 07 Jan 2013 10:30:53 -0600
Message-ID: <20130107163053.5102.60322.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4217e49..469ba9b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -54,7 +54,7 @@
 #include "hpsa.h"
 
 /* HPSA_DRIVER_VERSION must be 3 byte values (0-255) separated by '.' */
-#define HPSA_DRIVER_VERSION "2.0.2-1"
+#define HPSA_DRIVER_VERSION "3.2.0"
 #define DRIVER_NAME "HP HPSA Driver (v " HPSA_DRIVER_VERSION ")"
 #define HPSA "hpsa"
 
