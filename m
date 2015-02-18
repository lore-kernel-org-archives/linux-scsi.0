From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 0/4] scsi_debug cleanup
Date: Thu, 19 Feb 2015 00:31:35 +0200
Message-ID: <1424298699-2581-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25289 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbBRWdO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2015 17:33:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

I did some minor code cleanups while playing with 
scsi_debug module

Tomas Winkler (4):
  scsi_debug: define pr_fmt() for consistent logging
  scsi_debug: use SCSI_W_LUN_REPORT_LUNS instead of
    SAM2_WLUN_REPORT_LUNS;
  scsi_debug: vfree is null safe so drop the check
  scsi_debug: make dump_sector static

 drivers/scsi/scsi_debug.c | 143 ++++++++++++++++++++--------------------------
 1 file changed, 63 insertions(+), 80 deletions(-)

-- 
1.9.3

