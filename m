From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 0/2] qla1280: driver clean up, error recovery rewrite
Date: Wed, 08 Apr 2009 14:33:10 -0500
Message-ID: <49DCFBF6.8050007@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.156.57]:51697 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753083AbZDHTdM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Apr 2009 15:33:12 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A657AC001
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2009 12:33:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@sgi.com>

The first of the following two patches contains the removal
of some unneeded, inactive and unused code, some trivial
corrections to comments and a printk, and the return of a
proper status in qla1280_queuecommand.  No fundamental logic
changes are made.

The second of the two patches reworks driver error recovery.
The driver now waits for the scsi commands associated with a
particular error recovery step to be returned to the mid-layer,
and returns the appropriate SUCCESS or FAILED status.  Removes
unneeded polling of chip for interrupts.

This patch also bumps the driver version number.

These patches apply to linux-2.6.30-rc1.

Signed-off-by: Michael Reed <mdr@sgi.com>

