From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration
Date: Tue, 9 Dec 2008 14:15:22 -0800
Message-ID: <200812092215.mB9MFMZt015198@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:7627 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360AbYLIWOI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2008 17:14:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH v2 0/2 2.6.29] cxgb3i -- open-iscsi initiator acceleration 

From: Karen Xie <kxie@chelsio.com>

Here is the updated patchset for adding cxgb3i iscsi initiator.

The updated version incorporates the comments from Mike and Boaz:
- remove the cxgb3 sysfs entry for the private iscsi ip address, it can be
  accessed from iscsi.
- in cxgb3i.txt, added error message logged for not setting MaxRecvDataSegmentLength properly.
- renamed cxgb3i Makefile to Kbuild
- removed "select ISCSI_TCP" in Kconfig
- consistent handling of AHS: on tx, reserve rooms for AHS; on rx, assume we could receive AHS.
- add support of bi-directional commands for ddp setup,

The cxgb3i driver, especially the part handles the offloaded iscsi tcp connection mangement, has gone through the netdev review (http://marc.info/?l=linux-netdev&m=121944339211552, http://marc.info/?l=linux-netdev&m=121989660016124).

The cxgb3i driver provides iscsi acceleration (PDU offload and payload data direct placement) to the open-iscsi initiator. It accesses the hardware through the cxgb3 module.

Thanks.
Karen
