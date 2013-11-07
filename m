From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/11] hpsa: add MSA 2040 to list of external target devices
Date: Thu, 07 Nov 2013 10:46:00 -0600
Message-ID: <20131107164600.3504.47481.stgit@beardog.cce.hp.com>
References: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45891 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab3KGQqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:46:01 -0500
In-Reply-To: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Scott Teel <scott.teel@hp.com>
Acked-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 752d234..fdc2228 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1778,6 +1778,7 @@ static unsigned char *ext_target_model[] = {
 	"MSA2312",
 	"MSA2324",
 	"P2000 G3 SAS",
+	"MSA 2040 SAS",
 	NULL,
 };
 

