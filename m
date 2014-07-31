From: Anish Bhatt <anish@chelsio.com>
Subject: [scsi/net-next] Pulling in net-next changes
Date: Thu, 31 Jul 2014 12:40:08 -0700
Message-ID: <1406835608-17908-1-git-send-email-anish@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:52589
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750709AbaGaTm5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jul 2014 15:42:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: hch@infradead.org, michaelc@cs.wisc.edu, jbottomley@parallels.com, kxie@chelsio.com, Anish Bhatt <anish@chelsio.com>

Christoph/James/Mike
	Is there a timeline for pulling in the cxgb4i changes from net-next,
or a specific way to ask for it ? We have more changes in queue for cxgb4i &
libiscsi, and I would rather have the cxgb4i up to date in the scsi tree
before we do that to avoid any potentil issues in the future.

Last change to cxgb4i was in net-next tree was
e81fbf6cd652 ("libcxgbi:cxgb4i Guard ipv6 code with a config check")

-Anish

