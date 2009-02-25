From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 0/2 2.6.29-rc] cxgb3i -- handles chip reset
Date: Tue, 24 Feb 2009 17:28:09 -0800
Message-ID: <200902250128.n1P1S9IC007732@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:6291 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZBYBYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 20:24:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 0/2 2.6.29-rc] cxgb3i -- handling of chip reset

From: Karen Xie <kxie@chelsio.com>

The following patches added support of the cxgb3 chip reset. The reset could
happen due to EEH event or a fatal error. The cxgb3i would re-initialize the
hardware and its offload function. The iscsi error recovery mechanism will
re-establish the tcp connection after reset.

The patches are based on scsi-rc-fixes-2.6 git.

The cxgb3i portion of the patch requires the the following cxgb3 patch in the
linux-next git tree:
(http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=cb0bc205959bf8c60acae9c71f3da0597e756f8e).

Thanks.
Karen
