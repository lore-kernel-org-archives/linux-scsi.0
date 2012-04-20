From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 15/17] hpsa: add new RAID level "1(ADM)"
Date: Fri, 20 Apr 2012 10:07:37 -0500
Message-ID: <20120420150737.10596.86902.stgit@beardog.cce.hp.com>
References: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120420150349.10596.73732.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, matthew.gates@hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Mike Miller <mikem@beardog.cce.hp.com>

Signed-off-by: Mike Miller <mikem@beardog.cce.hp.com>
Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 67a0ad0..8213875 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -379,7 +379,7 @@ static inline int is_logical_dev_addr_mode(unsigned char scsi3addr[])
 }
 
 static const char *raid_label[] = { "0", "4", "1(1+0)", "5", "5+1", "ADG",
-	"UNKNOWN"
+	"1(ADM)", "UNKNOWN"
 };
 #define RAID_UNKNOWN (ARRAY_SIZE(raid_label) - 1)
 
