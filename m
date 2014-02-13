From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv7 0/3] Display EVPD pages in sysfs
Date: Thu, 13 Feb 2014 11:07:09 +0100
Message-ID: <1392286032-85036-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:32970 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbaBMKHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Feb 2014 05:07:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Hi all,

After discussion with jejb I've dropped the EVPD parsing.
So with this version we're just displaying the EVPD page
0x80 and 0x83 as hexdumps; no parsing is attempted.
This drastically simplifies the patch, and we don't
have to worry about any parsing errors in kernel space.

Hannes Reinecke (3):
  scsi_sysfs: Implement 'is_visible' callback
  Add EVPD page 0x83 to sysfs
  Add EVPD page 0x80 to sysfs

 drivers/scsi/scsi.c        | 104 ++++++++++++++++++--
 drivers/scsi/scsi_scan.c   |   3 +
 drivers/scsi/scsi_sysfs.c  | 229 +++++++++++++++++++++++++++------------------
 include/scsi/scsi.h        |   4 +-
 include/scsi/scsi_device.h |   5 +
 5 files changed, 245 insertions(+), 100 deletions(-)

-- 
1.7.12.4

