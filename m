From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: devinfo: remove DF arrays from HP
Date: Thu, 15 Mar 2018 19:01:49 +0100
Message-ID: <20180315180149.30560-1-xose.vazquez@gmail.com>
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
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Takahiro Yasui <takahiro.yasui@hitachivantara.com>, device-mapper development <dm-devel@redhat.com>, Mike Christie <mchristi@redhat.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Anthony Cheung <anthony.cheung@hpe.com>
List-Id: linux-scsi@vger.kernel.org

Matthias did confirm that there are no such devices.

Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Anthony Cheung <anthony.cheung@hpe.com>
Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index f3b117246d47..b119b5bfb4d3 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -187,8 +187,6 @@ static struct {
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
 	{"HP", "C3323-300", "4269", BLIST_NOTQ},
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
-	{"HP", "DF400", "*", BLIST_REPORTLUN2},
-	{"HP", "DF500", "*", BLIST_REPORTLUN2},
 	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
-- 
2.14.3
