From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/2] [PATCH/RESEND] Stop scsi eh when fast_io_fail_tmo fires
Date: Thu, 01 Apr 2010 13:48:48 +0200
Message-ID: <20100401114848.628357000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60661 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594Ab0DAL5l (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2010 07:57:41 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.1/8.13.1) with ESMTP id o31BveML020637
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 11:57:40 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o31BveDJ1732832
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o31Bvdgl021113
	for <linux-scsi@vger.kernel.org>; Thu, 1 Apr 2010 13:57:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

James,

these are the same two patches i submitted to linux-scsi before. The
initial submission went only to linux-scsi, so here it is again with
the appropriate cc list. The patches solve the problem of the scsi eh
blocking the host until the dev_loss_tmo fires, allowing the scsi eh
to stop already when the fast_io_fail_tmo fires. Hannes and Mike agree
with this approach.

The patches apply to both, the current scsi-misc and the current
scsi-rc-fixes tree, i am not quite sure which tree would be more
appropriate.

--
Christof
