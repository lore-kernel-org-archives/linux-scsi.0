From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 071/183] scsi: devinfo: fix format of the device list
Date: Wed, 25 Apr 2018 12:34:51 +0200
Message-ID: <20180425103245.371701501@linuxfoundation.org>
References: <20180425103242.532713678@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180425103242.532713678@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>


[ Upstream commit 3f884a0a8bdf28cfd1e9987d54d83350096cdd46 ]

Replace "" with NULL for product revision level, and merge TEXEL
duplicate entries.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_devinfo.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -109,8 +109,8 @@ static struct {
 	 * seagate controller, which causes SCSI code to reset bus.
 	 */
 	{"HP", "C1750A", "3226", BLIST_NOLUN},		/* scanjet iic */
-	{"HP", "C1790A", "", BLIST_NOLUN},		/* scanjet iip */
-	{"HP", "C2500A", "", BLIST_NOLUN},		/* scanjet iicx */
+	{"HP", "C1790A", NULL, BLIST_NOLUN},		/* scanjet iip */
+	{"HP", "C2500A", NULL, BLIST_NOLUN},		/* scanjet iicx */
 	{"MEDIAVIS", "CDR-H93MV", "1.31", BLIST_NOLUN},	/* locks up */
 	{"MICROTEK", "ScanMaker II", "5.61", BLIST_NOLUN},	/* responds to all lun */
 	{"MITSUMI", "CD-R CR-2201CS", "6119", BLIST_NOLUN},	/* locks up */
@@ -120,7 +120,7 @@ static struct {
 	{"QUANTUM", "FIREBALL ST4.3S", "0F0C", BLIST_NOLUN},	/* locks up */
 	{"RELISYS", "Scorpio", NULL, BLIST_NOLUN},	/* responds to all lun */
 	{"SANKYO", "CP525", "6.64", BLIST_NOLUN},	/* causes failed REQ SENSE, extra reset */
-	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},
+	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN | BLIST_BORKEN},
 	{"transtec", "T5008", "0001", BLIST_NOREPORTLUN },
 	{"YAMAHA", "CDR100", "1.00", BLIST_NOLUN},	/* locks up */
 	{"YAMAHA", "CDR102", "1.00", BLIST_NOLUN},	/* locks up */
@@ -255,7 +255,6 @@ static struct {
 	{"ST650211", "CF", NULL, BLIST_RETRY_HWERROR},
 	{"SUN", "T300", "*", BLIST_SPARSELUN},
 	{"SUN", "T4", "*", BLIST_SPARSELUN},
-	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
 	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
