From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: Submission of patches for Error Handling V2
Date: Sat, 20 Feb 2010 08:01:08 +0530
Message-ID: <20100220023034.GA13528@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53349 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754435Ab0BTCbJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:31:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi James

	 I have redone the patches to include the suggestions made by Mike Christie.
These patches  are made over scsi-misc tree.

The current patches are

Patch[1/7]: Modified target reset handling  for libiscsi and other drivers
Patch[2/7]: Cleaned up device and target reset handling 
Patch[3/7]: Fix for a possible sleep while holding spin_lock
Patch[4/7]: Cleanup of abort handling
Patch[5/7]: Removing some debug prints
Patch[6/7]: Ensure all connections have resources allocated
Patch[7/7]: Allocate only one EQ if msix not enabled

	I request you to apply these patches to your scsi-misc tree 

Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

