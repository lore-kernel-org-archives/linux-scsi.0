From: Ankit Jain <jankit@suse.de>
Subject: [PATCH] [scsi] Blacklist Traxdata CDR4120 and IOMEGA Zip drive to
 avoid lock ups.
Date: Fri, 03 Jun 2011 19:23:47 +0530
Message-ID: <4DE8E76B.30301@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:40468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503Ab1FCNwQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2011 09:52:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: werner@novell.com, James Bottomley <James.Bottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

From: Werner Fink <werner@novell.com>
Subject: [PATCH] [scsi] Blacklist Traxdata CDR4120 and IOMEGA Zip drive to avoid lock ups.

This patch resulted from the discussion at
https://bugzilla.novell.com/show_bug.cgi?id=679277,
https://bugzilla.novell.com/show_bug.cgi?id=681840 .

Signed-off-by: Werner Fink <werner@novell.com>
Signed-off-by: James Bottomley <James.Bottomley@parallels.com>
---
 drivers/scsi/scsi_devinfo.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 82e9e5c..cf8dfab 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -197,6 +197,7 @@ static struct {
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2105", NULL, BLIST_RETRY_HWERROR},
 	{"iomega", "jaz 1GB", "J.86", BLIST_NOTQ | BLIST_NOLUN},
+	{"IOMEGA", "ZIP", NULL, BLIST_NOTQ | BLIST_NOLUN},
 	{"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
 	{"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
@@ -243,6 +244,7 @@ static struct {
 	{"Tornado-", "F4", "*", BLIST_NOREPORTLUN},
 	{"TOSHIBA", "CDROM", NULL, BLIST_ISROM},
 	{"TOSHIBA", "CD-ROM", NULL, BLIST_ISROM},
+	{"Traxdata", "CDR4120", NULL, BLIST_NOLUN},	/* locks up */
 	{"USB2.0", "SMARTMEDIA/XD", NULL, BLIST_FORCELUN | BLIST_INQUIRY_36},
 	{"WangDAT", "Model 2600", "01.7", BLIST_SELECT_NO_ATN},
 	{"WangDAT", "Model 3200", "02.2", BLIST_SELECT_NO_ATN},
-- 
1.7.1

-- 
Ankit Jain
SUSE Labs
