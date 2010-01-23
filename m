From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Updates to the driver
Date: Sat, 23 Jan 2010 05:33:40 +0530
Message-ID: <20100123000325.GA12541@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:39825 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751669Ab0AWADi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:03:38 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

Hi James

	These patches contains some updates for the be2iscsi driver
intended to go into scsi-misc tree

	These patches are created using the latest scsi-misc tree after
applying the following patches sent earlier

http://www.spinics.net/lists/linux-scsi/msg41396.html
http://www.spinics.net/lists/linux-scsi/msg41397.html
http://www.spinics.net/lists/linux-scsi/msg41398.html

The current patches are

Patch[1/8]: Remove Ring mode from driver
Patch[2/8]: changing copyright to 2010
Patch[3/8]: Fix for first_burst
Patch[4/8]: Proper checking of phba state
Patch[5/8]: correcting the return value
Patch[6/8]: Ensure clean reuse of wrb
Patch[7/8]: changing the chip opcode for TEXT
Patch[8/8]: correction in the claculation for num_cxn_wrb

	I request you to apply these patches to your scsi-misc tree 

Thank You

Jayamohan Kallickal

Signed-off-by:  Jayamohan Kallickal <jayamohank@serverengines.com>

---

