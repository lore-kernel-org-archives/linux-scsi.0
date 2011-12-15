From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v2 0/2] fixes for ata port runtime pm support
Date: Thu, 15 Dec 2011 09:36:01 +0800
Message-ID: <1323912963-26146-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628Ab1LOBgN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2011 20:36:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <JBottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org

Hi Jeff,

Here are the v2 fixes for ata port runtime pm support.
Applied on top of linux-next-20111214 tree.

Changes in v2:
- Drop the patch "[SCSI] sd: fix runtime status check in sd_shutdown".
  It's no longer needed with commit fe6b91f(PM / Driver core: leave
  runtime PM enabled during system shutdown).
- Add Ack from Alan

v1: https://lkml.org/lkml/2011/12/13/443

Lin Ming (2):
      [SCSI]: runtime resume parent for child's system-resume
      ata: update ata port's runtime status during system resume

 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 drivers/scsi/scsi_pm.c    |   11 ++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

Thanks,
Lin Ming
