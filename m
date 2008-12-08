From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 0/3 2.6.29] cxgb3i -- add open-iscsi initiator acceleration
Date: Mon, 8 Dec 2008 12:29:36 -0800
Message-ID: <200812082029.mB8KTaoY029228@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:16868 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYLHU2j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Dec 2008 15:28:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 0/3 2.6.29] cxgb3i -- open-iscsi initiator acceleration 

From: Karen Xie <kxie@chelsio.com>

Hi, James,

Here is the complete patchset for adding cxgb3i iscsi initiator. This patchset is for 2.6.29. It is based on the scsi-misc-2.6 git tree.

The cxgb3i driver, especially the part handles the offloaded iscsi tcp
connection mangement, has gone through the netdev review (
http://marc.info/?l=linux-netdev&m=121944339211552,
http://marc.info/?l=linux-netdev&m=121989660016124).

The cxgb3i driver provides iscsi acceleration (PDU offload and payload data
direct placement) to the open-iscsi initiator. It accesses the hardware through
the cxgb3 module.

Thanks.
Karen
