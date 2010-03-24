From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/2] Stop scsi eh when fast_io_fail_tmo fires
Date: Wed, 24 Mar 2010 16:50:29 +0100
Message-ID: <20100324155029.241441000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:55276 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab0CXP63 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2010 11:58:29 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.1/8.13.1) with ESMTP id o2OFwRi1006889
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 15:58:27 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o2OFwRBC1437716
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:58:27 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o2OFwRIP008984
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:58:27 +0100
Received: from tuxmaker.boeblingen.de.ibm.com (tuxmaker.boeblingen.de.ibm.com [9.152.85.9])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id o2OFwRuY008979
	for <linux-scsi@vger.kernel.org>; Wed, 24 Mar 2010 16:58:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

As a follow-up for the draft mentioned in
http://marc.info/?l=linux-scsi&m=126926716605409&w=2

The patches allow the scsi eh to exit early when the fast_io_fail_tmo
fires. This fixes the problem that the scsi eh will block until the
dev_loss_tmo fires, thus potentially blocking the scsi host for a very
long time.

Comments?

--
Christof Schmitt
