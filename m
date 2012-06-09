From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 2/2] scsi: properly initialize atomic_t scsi_host_next_hn
Date: Sat,  9 Jun 2012 07:03:39 -0700
Message-ID: <1339250619-1561-2-git-send-email-johunt@akamai.com>
References: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Josh Hunt <johunt@akamai.com>
List-Id: linux-scsi@vger.kernel.org

Initialize atomic_t scsi_host_next_hn as per the guidelines defined in Documentation/atomic_ops.txt

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/scsi/hosts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index a3a056a..2b6a03d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -42,7 +42,7 @@
 #include "scsi_logging.h"
 
 
-static atomic_t scsi_host_next_hn;	/* host_no for next new host */
+static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
 
 
 static void scsi_host_cls_release(struct device *dev)
-- 
1.7.0.4
