From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.15 100/128] scsi: devinfo: apply to HP XP the same flags as Hitachi VSP
Date: Fri, 16 Mar 2018 16:24:01 +0100
Message-ID: <20180316152341.533590815@linuxfoundation.org>
References: <20180316152336.199007505@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180316152336.199007505@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Takahiro Yasui <takahiro.yasui@hds.com>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>


[ Upstream commit b369a0471503130cfc74f9f62071db97f48948c3 ]

Commit 56f3d383f37b ("scsi: scsi_devinfo: Add TRY_VPD_PAGES to HITACHI
OPEN-V blacklist entry") modified some Hitachi entries:

    HITACHI is always supporting VPD pages, even though it's claiming to
    support SCSI Revision 3 only.

The same should have been done also for HP-rebranded.

[mkp: checkpatch and tweaked commit message]

Cc: Hannes Reinecke <hare@suse.de>
Cc: Takahiro Yasui <takahiro.yasui@hds.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_devinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -181,7 +181,7 @@ static struct {
 	{"HITACHI", "6586-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HITACHI", "6588-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "A6189A", NULL, BLIST_SPARSELUN | BLIST_LARGELUN},	/* HP VA7400 */
-	{"HP", "OPEN-", "*", BLIST_REPORTLUN2}, /* HP XP Arrays */
+	{"HP", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES}, /* HP XP Arrays */
 	{"HP", "NetRAID-4M", NULL, BLIST_FORCELUN},
 	{"HP", "HSV100", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"HP", "C1557A", NULL, BLIST_FORCELUN},
