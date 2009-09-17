From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 0/1] Fix data buffer handling in sg driver
Date: Thu, 17 Sep 2009 09:10:13 +0200
Message-ID: <20090917071013.472963000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8-bp.emea.ibm.com ([195.212.17.168]:43990 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758498AbZIQHPw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 03:15:52 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.1/8.13.1) with ESMTP id n8H7FsEn019275
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 07:15:54 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n8H7Fsqk2609194
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 09:15:54 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n8H7Frai022944
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2009 09:15:54 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

This fixes a problem in the sg driver that occurs with
CONFIG_DEBUG_PAGEALLOC enabled. It is the same patch as in
http://marc.info/?l=linux-scsi&m=125303366703782&w=2
I only added the acked-by from Fujita and the CC to
stable@kernel.org

--
Christof
