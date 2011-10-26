From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 1/5] hpsa: set max sectors instead of taking the default
Date: Wed, 26 Oct 2011 16:20:53 -0500
Message-ID: <20111026212053.15570.27048.stgit@beardog.cce.hp.com>
References: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111026212006.15570.26229.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Set the max hardware sectors in the SCSI host template to 8192
to allow for larger i/o's (8192 is the same limit the cciss
driver currently has.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b200b73..9b12aea 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -484,6 +484,7 @@ static struct scsi_host_template hpsa_driver_template = {
 #endif
 	.sdev_attrs = hpsa_sdev_attrs,
 	.shost_attrs = hpsa_shost_attrs,
+	.max_sectors = 8192,
 };
 
 
