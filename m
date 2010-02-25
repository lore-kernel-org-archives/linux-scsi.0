From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/9] hpsa: driver updates
Date: Thu, 25 Feb 2010 14:02:46 -0600
Message-ID: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20851 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0BYT7h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:59:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

The two biggest things are removal of the scan thread, and
support for more scatter gather entries.

Mike Miller (1):
      hpsa: remove scan thread

Stephen M. Cameron (8):
      hpsa: allow modifying device queue depth.
      hpsa: fix firmwart typo
      hpsa: fix scsi status mis-shift
      hpsa: return -ENOMEM, not -1
      hpsa: mark hpsa_pci_init as __devinit
      hpsa: Clarify calculation of padding for commandlist structure
      hpsa: Increase the number of scatter gather elements supported.
      hpsa: remove unused members next, prev, and retry_count from command list structure.


 drivers/scsi/hpsa.c     |  330 ++++++++++++++++++++++-------------------------
 drivers/scsi/hpsa.h     |    7 +
 drivers/scsi/hpsa_cmd.h |   20 ++-
 3 files changed, 168 insertions(+), 189 deletions(-)

-- 
-- steve
