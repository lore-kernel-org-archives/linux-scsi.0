From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 0/5 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX
Date: Mon, 9 Feb 2009 18:10:06 -0800
Message-ID: <200902100210.n1A2A6vv019799@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:8611 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbZBJCI5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2009 21:08:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 0/5 2.6.29-rc] cxgb3i -- bug fixes for 2.6.29-rcX 

From: Karen Xie <kxie@chelsio.com>

The patches are based on scsi-rc-fixes-2.6 git.

The changes include:

- Added per-task data to track the state of the pdus to be transmitted.
- fixed tx work-request credit array.
- fixed a bug in tx pdu construction where we could over-run the skb's fragment list.
- Added missing include file in cxgb3i_ddp.h.
- Update version number to 1.0.1.


Thanks.
Karen
