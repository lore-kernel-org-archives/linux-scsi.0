From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv6 0/3] Display EVPD pages in sysfs
Date: Wed, 12 Feb 2014 11:24:28 +0100
Message-ID: <1392200671-35624-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840AbaBLKYh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Feb 2014 05:24:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>

Hi all,

This version now includes the review from hch, and I've
added a new patch to display EVPD page 0x80 in sysfs, too.
And some more sanity checks to play nice with broken devices.

Hannes Reinecke (3):
  scsi_sysfs: Implement 'is_visible' callback
  Add EVPD page 0x83 entries to sysfs
  Add EVPD page 0x80 to sysfs

 drivers/scsi/scsi_scan.c   |   5 +
 drivers/scsi/scsi_sysfs.c  | 559 +++++++++++++++++++++++++++++++++++++--------
 include/scsi/scsi.h        |   4 +-
 include/scsi/scsi_device.h |   6 +
 4 files changed, 481 insertions(+), 93 deletions(-)

-- 
1.7.12.4

