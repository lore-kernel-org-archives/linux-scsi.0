From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] 2.5 scsi_error.c cleanup update
Date: Thu, 12 Sep 2002 16:42:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912234206.GA4456@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e31.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id g8CNf2g2050340
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2002 19:41:02 -0400
Received: from dyn9-47-17-195 (dyn9-47-17-67.beaverton.ibm.com [9.47.17.67])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g8CNf172216250
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2002 17:41:01 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have updated the scsi_error cleanup patch for 2.5.34. 
	* This update does not include the change mentioned in earlier
	  mail regarding retry of commands using stale values. I wanted
	  to separate cleanup from functionality changes. The
	  functionality changes will build on this cleanup which
	  hopefully will allow smaller diffs in email.
	* This patch includes a typo semi-colon bug fix in
	  scsi_unjam_host that patman pointed out

Sorry that the patch is not in-lined as I tried to but the size must be
to big for linux-scsi (~105k) and it was tossed in the bit bucket. The
patch is available at:
http://www-124.ibm.com/storageio/gen-io/patch-scsi_error-2.5.34-1.gz


 hosts.c      |   42 
 hosts.h      |    7 
 scsi.c       |   59 -
 scsi.h       |   24 
 scsi_error.c | 2612 +++++++++++++++++++++++++----------------------------------
 scsi_queue.c |    6 
 6 files changed, 1217 insertions(+), 1533 deletions(-)

-andmike
-- 
Michael Anderson
andmike@us.ibm.com
