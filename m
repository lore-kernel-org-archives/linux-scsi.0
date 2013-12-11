From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] SCSI SRP transport layer patches for kernel 3.14
Date: Wed, 11 Dec 2013 17:04:09 +0100
Message-ID: <52A88CF9.206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:39646 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3LKQEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2013 11:04:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, James Bottomley <JBottomley@Parallels.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

This series of three patches is what I came up with after several weeks
of path failover testing of the 3.13-rc1 IB/SRP initiator on a large
setup. The patches in this series are:
* Make SRP transport layer behavior more consistent with that of the FC
  transport layer.
* Fix a rare race condition triggered by path failover.
* Document the rport state transitions.
