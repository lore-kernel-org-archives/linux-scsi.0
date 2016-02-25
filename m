From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv2] Enable iBFT IPv6 booting with prefix length
Date: Thu, 25 Feb 2016 10:15:49 -0800
Message-ID: <cover.1456423714.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381AbcBYSTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Feb 2016 13:19:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, michaelc@cs.wisc.edu, konrad@kernel.org, Lee Duncan <lduncan@suse.com>

It turns out that IPv6 doesn't care about netmask, but
instead uses "prefix length" to determine the subnet, but
the iBFT subsystem still just supports netmask.

These two patches enable IPv6 iBFT (iscsi booting)
by adding support for IPv6 prefix and prefix length.
Open-iscsi changes to use these new values will be
introduced once these changes are present.

Hannes Reinecke (1):
  iscsi_ibft: Add prefix-len attr and display netmask

 drivers/firmware/iscsi_ibft.c    | 4 ++++
 drivers/scsi/iscsi_boot_sysfs.c  | 5 +++++
 include/linux/iscsi_boot_sysfs.h | 1 +
 3 files changed, 10 insertions(+)

-- 
1.8.5.2

