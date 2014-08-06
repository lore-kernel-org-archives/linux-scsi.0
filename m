From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 0/1] libiscsi : T10 DIF support
Date: Wed,  6 Aug 2014 15:37:47 -0700
Message-ID: <1407364668-20931-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:34762
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754476AbaHFWkb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 18:40:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

The following patch adds T10 DIF support to libiscsi. I didn't see any merge
window messages on linux-scsi, I hope I'm not sending this out of sync.
-Anish

Anish Bhatt (1):
  libiscsi : Add T10 Data Integrity Feature support

 drivers/scsi/libiscsi.c     |  61 +++++++--
 drivers/scsi/libiscsi_tcp.c | 296 ++++++++++++++++++++++++++++++++++++++++----
 include/scsi/libiscsi.h     |   6 +
 include/scsi/libiscsi_tcp.h |  22 ++++
 4 files changed, 349 insertions(+), 36 deletions(-)

-- 
2.0.3

