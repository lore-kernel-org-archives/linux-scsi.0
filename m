From: Dave Jones <davej@redhat.com>
Subject: blacklist microtek scanmaker III
Date: Wed, 23 Feb 2005 14:31:38 -0500
Message-ID: <20050223193138.GI32098@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mx1.redhat.com ([66.187.233.31]:21385 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S261543AbVBWTbi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2005 14:31:38 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11/8.12.11) with ESMTP id j1NJVc6g008137
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 14:31:38 -0500
Received: from devserv.devel.redhat.com (devserv.devel.redhat.com [172.16.58.1])
	by int-mx1.corp.redhat.com (8.11.6/8.11.6) with ESMTP id j1NJVcK11052
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 14:31:38 -0500
Received: from devserv.devel.redhat.com (localhost.localdomain [127.0.0.1])
	by devserv.devel.redhat.com (8.12.11/8.12.11) with ESMTP id j1NJVcW2018679
	for <linux-scsi@vger.kernel.org>; Wed, 23 Feb 2005 14:31:38 -0500
Received: (from davej@localhost)
	by devserv.devel.redhat.com (8.12.11/8.12.11/Submit) id j1NJVcLO018675
	for linux-scsi@vger.kernel.org; Wed, 23 Feb 2005 14:31:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

To try and escape the madness of adding a zillion USB card readers
to the SCSI whitelist, I flipped the scan all lun's by default switch
in the fedora kernel recently to see just what breaks, in the hope
of moving from a whitelist solution to a blacklist.

Here's the first (hopefully of not too many) devices that broke.
(See https://bugzilla.redhat.com/beta/show_bug.cgi?id=149402 for more info)

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.10/drivers/scsi/scsi_devinfo.c~	2005-02-23 14:27:53.000000000 -0500
+++ linux-2.6.10/drivers/scsi/scsi_devinfo.c	2005-02-23 14:29:06.000000000 -0500
@@ -63,6 +63,7 @@ static struct {
 	{"MAXTOR", "XT-4170S", "B5A", BLIST_NOLUN},	/* locks up */
 	{"MAXTOR", "XT-8760S", "B7B", BLIST_NOLUN},	/* locks up */
 	{"MEDIAVIS", "RENO CD-ROMX2A", "2.03", BLIST_NOLUN},	/* responds to all lun */
+	{"MICROTEK", "ScanMakerIII", "2.30", BLIST_NOLUN},	/* responds to all lun */
 	{"NEC", "CD-ROM DRIVE:841", "1.0", BLIST_NOLUN},/* locks up */
 	{"PHILIPS", "PCA80SC", "V4-2", BLIST_NOLUN},	/* responds to all lun */
 	{"RODIME", "RO3000S", "2.33", BLIST_NOLUN},	/* locks up */
