From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 0/2] Fixes for fnic
Date: Mon, 13 Jun 2011 21:20:20 -0700
Message-ID: <20110614041741.5915.8518.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:11961 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1FNEUV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2011 00:20:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, abjoglek@cisco.com
Cc: vbhamidi@cisco.com, buchino@cisco.com

The following series implements a bug fix for fnic and updates Maintainers
list.

The patches are based off scsi-misc tree.

---

Abhijeet Joglekar (2):
      fnic: Update Maintainers list for fnic.
      fnic: fix incorrect use of SLAB_CACHE_DMA flag


 MAINTAINERS                   |    3 ++-
 drivers/scsi/fnic/fnic.h      |    2 +-
 drivers/scsi/fnic/fnic_main.c |   21 ++++-----------------
 drivers/scsi/fnic/fnic_scsi.c |    2 +-
 4 files changed, 8 insertions(+), 20 deletions(-)

-- 
Signature
