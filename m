From: Michal Marek <mmarek@suse.cz>
Subject: [PATCH 22/34] scsi/in2000: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:09 +0200
Message-ID: <1302015561-21047-23-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Return-path: <linux-kbuild-owner@vger.kernel.org>
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kbuild-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/scsi/in2000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 6568aab..6096d93 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2228,7 +2228,7 @@ static int in2000_proc_info(struct Scsi_Host *instance, char *buf, char **start,
 	bp = buf;
 	*bp = '\0';
 	if (hd->proc & PR_VERSION) {
-		sprintf(tbuf, "\nVersion %s - %s. Compiled %s %s", IN2000_VERSION, IN2000_DATE, __DATE__, __TIME__);
+		sprintf(tbuf, "\nVersion %s - %s.", IN2000_VERSION, IN2000_DATE);
 		strcat(bp, tbuf);
 	}
 	if (hd->proc & PR_INFO) {
-- 
1.7.4.1

