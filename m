From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/17] hpsa: add new RAID level "1(ADM)"
Date: Tue, 01 May 2012 11:43:32 -0500
Message-ID: <20120501164332.11705.16988.stgit@beardog.cce.hp.com>
References: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120501163819.11705.10299.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Mike Miller <mikem@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 1351ddf..84239d8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -380,7 +380,7 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 }
 
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
-	"UNKNOWN"
+	"1(ADM)", "UNKNOWN"
 };
 #define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
 
