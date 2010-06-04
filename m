From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 5/5] cciss: change pad value from 32 to 0
Date: Fri, 4 Jun 2010 15:16:58 -0500
Message-ID: <20100604201658.GE30870@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, dab@hp.com, scameron@beardog.cce.hp.com, gerry.morong@hp.com, mike.miller@hp.com, scott.benesh@hp.com, scott.stacy.teel@hp.com, tom.lawler@hp.com, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

Patch 5 of 5
cciss: change padding from 32 to 0 since it has the same effect
Change the command padding on 32-bit systems to 0 since setting it to 32 has
the identical effect.

From: Mike Miller <mike.miller@hp.com>

Signed-off-by: Mike Miller <mike.miller@hp.com>
Cc: Stephen M. Cameron <scameron@beardog.cce.hp.com>, iss_storagedev@hp.com
---
 drivers/block/cciss_cmd.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss_cmd.h b/drivers/block/cciss_cmd.h
index eda6a8e..936b966 100644
--- a/drivers/block/cciss_cmd.h
+++ b/drivers/block/cciss_cmd.h
@@ -177,7 +177,7 @@ typedef struct _SGDescriptor_struct {
 #define COMMANDLIST_ALIGNMENT (32)
 #define IS_64_BIT ((sizeof(long) - 4)/4)
 #define IS_32_BIT (!IS_64_BIT)
-#define PAD_32 (32)
+#define PAD_32 (0)
 #define PAD_64 (4)
 #define PADSIZE (IS_32_BIT * PAD_32 + IS_64_BIT * PAD_64)
 #define DIRECT_LOOKUP_BIT 0x10
