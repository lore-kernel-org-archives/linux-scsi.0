From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 16/16] hpsa: add P2000 to list of shared SAS devices
Date: Tue, 03 May 2011 15:00:07 -0500
Message-ID: <20110503200007.5478.88000.stgit@beardog.cce.hp.com>
References: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:41372 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755053Ab1ECUAH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2011 16:00:07 -0400
In-Reply-To: <20110503195750.5478.54853.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Scott Teel <scott.stacy.teel@hp.com>
---
 drivers/scsi/hpsa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5c03cb5..cffc7bb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1591,6 +1591,7 @@ static unsigned char *msa2xxx_model[] = {
 	"MSA2024",
 	"MSA2312",
 	"MSA2324",
+	"P2000 G3 SAS",
 	NULL,
 };
 

