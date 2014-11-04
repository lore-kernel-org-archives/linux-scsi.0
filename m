From: Anish Bhatt <anish@chelsio.com>
Subject: [PATCH scsi 0/2] Bugfix & mainatainers update for cxgbi
Date: Tue,  4 Nov 2014 15:19:21 -0800
Message-ID: <1415143163-2326-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:56864
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751812AbaKDXVm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2014 18:21:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, jbottomley@parallels.com, michaelc@cs.wisc.edu, kxie@chelsio.com, manojmalviya@chelsio.com, Anish Bhatt <anish@chelsio.com>

First patch adds missing maintainers for cxgb3i/cxgb4i.
Second is a bugfix

Please apply on drivers-for-3.18

Anish Bhatt (2):
  cxgbi : Add Maintainer for cxgb3i/cxgb4i
  cxgb4i : Send abort_rpl correctly

 MAINTAINERS                        | 14 ++++++++++++++
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 15 +++++++++------
 drivers/scsi/cxgbi/libcxgbi.c      | 18 ++++++++----------
 3 files changed, 31 insertions(+), 16 deletions(-)

-- 
2.1.3

