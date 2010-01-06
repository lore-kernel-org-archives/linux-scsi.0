From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Bug Fixes Needed
Date: Thu, 7 Jan 2010 01:49:33 +0530
Message-ID: <20100106201918.GA19887@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:26817 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932717Ab0AFUTN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 15:19:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi James

	These patches contains some bug fixes that are important for
the driver.

These patches are created using the latest scsi-misc tree and after
applying the following patches sent earlier

http://www.spinics.net/lists/linux-scsi/msg41363.html
http://www.spinics.net/lists/linux-scsi/msg41364.html

		to
http://www.spinics.net/lists/linux-scsi/msg41375.html

The current patches are

[0001/3] :	Fixing-Bug-for-multiple-SGEs
[0002/3] : 	Fixing-the-number-of-SGE supported	
[0003/3] :	Fix-to-allow-driver-to-load-when-the-FW-allows more cids
		than driver supports  

I request you to apply these patches to your tree 

Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

