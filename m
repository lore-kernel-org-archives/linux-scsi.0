From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH RFC] scsi: devinfo: remove dasd devices from the
	scsi subsystem
Date: Fri, 16 Mar 2018 15:57:25 +0100
Message-ID: <20180316145725.15394-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: s390 ML <linux-s390@vger.kernel.org>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Takahiro Yasui <takahiro.yasui@hitachivantara.com>, device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Anthony Cheung <anthony.cheung@hpe.com>
List-Id: linux-scsi@vger.kernel.org

Only present through ccw bus.

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
Cc: Anthony Cheung <anthony.cheung@hpe.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: s390 ML <linux-s390@vger.kernel.org>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index b119b5bfb4d3..31985dd3f4b6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -175,11 +175,6 @@ static struct {
 	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"HITACHI", "HUS1530", "*", BLIST_NO_DIF},
 	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
-	{"HITACHI", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
 	{"HP", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
@@ -187,11 +182,6 @@ static struct {
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
-	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-	{"HP", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
-- 
2.14.3
