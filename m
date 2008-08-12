From: Martin Petermann <martin@linux.vnet.ibm.com>
Subject: [patch 0/1] [PATCH] scsi: fix check of PQ and PDT bits for WLUNs
Date: Tue, 12 Aug 2008 13:40:37 +0200
Message-ID: <20080812114037.963047000@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:4480 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYHLLmL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Aug 2008 07:42:11 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.13.8/8.13.8) with ESMTP id m7CBfNxW232834
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 11:41:23 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7CBfNRF3731546
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:41:23 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7CBfN1R022567
	for <linux-scsi@vger.kernel.org>; Tue, 12 Aug 2008 13:41:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-- 
