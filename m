From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: be2iscsi: Bug Fixes and bsg interface
Date: Wed, 4 Nov 2009 04:46:46 +0530
Message-ID: <20091103231630.GA2426@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:5478 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751165AbZKCXQf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 18:16:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu

Hi

 I am sending two patches.

1) The first patch contains bug fixes.

2) The second patch provides support to ad bsg interface.
 This patch is dependent on the patch from James Smart

   http://mail.spinics.net/lists/linux-scsi/msg40079.html

The patch was built on the latest tree at
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

I request that these patches  be applied to the next release

Thanks
Jay

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
