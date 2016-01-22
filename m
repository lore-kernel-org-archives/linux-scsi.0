From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 0/2] RESEND: Enable iBFT IPv6 booting with prefix length
Date: Fri, 22 Jan 2016 11:49:11 -0800
Message-ID: <cover.1453419653.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54942 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753002AbcAVTv2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 14:51:28 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id E8967AC01
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 19:51:25 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hare@suse.de, Lee Duncan <lduncan@suse.com>

[Resending. Apologies if you get this twice.]

It turns out that IPv6 doesn't care about netmask, but
instead uses "prefix length" to determine the subnet, but
the iBFT subsystem still just supports netmask.

These two patches enable IPv6 iBFT (iscsi booting)
by adding support for IPv6 prefix and prefix length.
Open-iscsi changes to use these new values will be
introduced once these changes are present.

Hannes Reinecke (2):
  iscsi_ibft: Add prefix-len attribute
  iscsi_ibft: Always display netmask

 drivers/firmware/iscsi_ibft.c    | 4 ++++
 drivers/scsi/iscsi_boot_sysfs.c  | 5 +++++
 include/linux/iscsi_boot_sysfs.h | 1 +
 3 files changed, 10 insertions(+)

-- 
1.8.5.2

