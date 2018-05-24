From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.16 108/161] scsi: devinfo: add HP DISK-SUBSYSTEM device, for HP XP arrays
Date: Thu, 24 May 2018 11:38:53 +0200
Message-ID: <20180524093031.355250272@linuxfoundation.org>
References: <20180524093018.331893860@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180524093018.331893860@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Anthony Cheung <anthony.cheung@hpe.com>, Takahiro Yasui <takahiro.yasui@hitachivantara.com>, Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, SCSI ML <linux-scsi@vger.kernel.org>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Sasha Levin <alexander.levin@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

4.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xose Vazquez Perez <xose.vazquez@gmail.com>

[ Upstream commit 5f96f42b76e00e2871033745ff029056cc725c76 ]

"The DISK-SUBSYSTEM is a special model name returned when LUs
are not installed. For example, when LU#0 is not installed in "OPEN-"
models, LU#0 is detected as the DISK-SUBSYSTEM model":
https://marc.info/?l=linux-scsi&m=125424006417825

It's missing for HP XP rebranded arrays, "HP"/"OPEN-".
Only the HITACHI one is present:
13f7e5acc8b329080672c13f05f252ace5b79825
627511e3e67553b04f6917c03e39b797df210e04

Cc: Anthony Cheung <anthony.cheung@hpe.com>
Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: SCSI ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -189,6 +189,7 @@ static struct {
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"HP", "DF400", "*", BLIST_REPORTLUN2},
 	{"HP", "DF500", "*", BLIST_REPORTLUN2},
+	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"HP", "OP-C-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3380-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"HP", "3390-", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
