From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3 v6] Fixes for SCSI device removal
Date: Fri, 04 May 2012 15:00:32 +0000
Message-ID: <4FA3EF10.3040104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:45294 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2EDPAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 11:00:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

This is version six of the SCSI device removal patches.

Changes compared to v5:
- Removed the function scsi_free_queue() and inlined that function
  in its callers.
- Added two additional patches.
