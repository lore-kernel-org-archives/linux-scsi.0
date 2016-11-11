From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH v2] scsi_devinfo: remove synchronous ALUA for
	NETAPP devices
Date: Fri, 11 Nov 2016 17:49:49 +0100
Message-ID: <20161111164949.2322-1-xose.vazquez@gmail.com>
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
Cc: Martin George <Martin.George@netapp.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, SCSI ML <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Steven Schremmer <Steven.Schremmer@netapp.com>, Robert Stankey <Robert.Stankey@netapp.com>, device-mapper development <dm-devel@redhat.com>, Sean Stewart <Sean.Stewart@netapp.com>
List-Id: linux-scsi@vger.kernel.org

NetApp did confirm this is not required.

Cc: Martin George <Martin.George@netapp.com>
Cc: Robert Stankey <Robert.Stankey@netapp.com>
Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
Cc: Sean Stewart <Sean.Stewart@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 2464569..28fea83 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -220,8 +220,6 @@ static struct {
 	{"NAKAMICH", "MJ-5.16S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
-	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
-	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.10.2
