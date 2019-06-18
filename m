From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/2] scsi: devinfo: BLIST_TRY_VPD_PAGES for SanDisk Cruzer Blade
Date: Mon, 17 Jun 2019 22:31:45 -0300
Message-ID: <20190618013146.21961-2-marcos.souza.org@gmail.com>
References: <20190618013146.21961-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190618013146.21961-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Currently, all USB devices skip VPD pages, even when the device supports
them (SPC-3 and later), but some of them support VPD, like Cruzer Blade.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a08ff3bd6310..df14597752ec 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -239,6 +239,8 @@ static struct {
 	{"LSI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"ENGENIO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"LENOVO", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SanDisk", "Cruzer Blade", NULL, BLIST_TRY_VPD_PAGES |
+		BLIST_INQUIRY_36},
 	{"SMSC", "USB 2 HS-CF", NULL, BLIST_SPARSELUN | BLIST_INQUIRY_36},
 	{"SONY", "CD-ROM CDU-8001", NULL, BLIST_BORKEN},
 	{"SONY", "TSL", NULL, BLIST_FORCELUN},		/* DDS3 & DDS4 autoloaders */
-- 
2.21.0
