From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 0/3 2.6.29] cxgb3i -- driver fixes & updates
Date: Sat, 6 Dec 2008 23:09:36 -0800
Message-ID: <200812070709.mB779a5T020861@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:1524 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYLGHIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 02:08:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 0/3 2.6.29] cxgb3i -- open-iscsi initiator acceleration 

From: Karen Xie <kxie@chelsio.com>

Hi, everyone,

This patchset is for 2.6.29.

It is based on the cxgb3i branch of Mike's linux-2.6-iscsi tree. It needs the
patch Mike sent several days ago on preparing the iscsi core libary for pdu
offload (http://marc.info/?l=linux-scsi&m=122819956917473).

The cxgb3i driver, especially the part handles the offloaded iscsi tcp
connection mangement, has gone through the netdev review (
http://marc.info/?l=linux-netdev&m=121944339211552,
http://marc.info/?l=linux-netdev&m=121989660016124).

The cxgb3i driver provides iscsi acceleration (PDU offload and payload data
direct placement) to the open-iscsi initiator. It accesses the hardware through
the cxgb3 module.

Thanks.
Karen
