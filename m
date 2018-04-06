From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] scsi: scsi_dh: replace too broad "TP9" string
	with the exact models
Date: Sat,  7 Apr 2018 00:47:23 +0200
Message-ID: <20180406224723.25414-1-xose.vazquez@gmail.com>
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
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>, DM ML <dm-devel@redhat.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

SGI/TP9100 is not a RDAC array:
    ^^^
https://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=libmultipath/hwtable.c;h=88b4700beb1d8940008020fbe4c3cd97d62f4a56;hb=HEAD#l235

This reverts partially the 35204772ea034b380bc9d8942699dc03898e5c13 commit

Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Cc: DM ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_dh.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index b88b5dbbc444..d2fc6521f8ad 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -58,7 +58,10 @@ static const struct scsi_dh_blist scsi_dh_blist[] = {
 	{"IBM", "3526",			"rdac", },
 	{"IBM", "3542",			"rdac", },
 	{"IBM", "3552",			"rdac", },
-	{"SGI", "TP9",			"rdac", },
+	{"SGI", "TP9300",		"rdac"},
+	{"SGI", "TP9400",		"rdac"},
+	{"SGI", "TP9500",		"rdac"},
+	{"SGI", "TP9700",		"rdac"},
 	{"SGI", "IS",			"rdac", },
 	{"STK", "OPENstorage",		"rdac", },
 	{"STK", "FLEXLINE 380",		"rdac", },
-- 
2.14.3
