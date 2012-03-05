From: Sathisha Nanjappa <sathisha.nanjappa@hp.com>
Subject: [PATCH] bug fix for 42142
Date: Mon,  5 Mar 2012 12:13:18 -0800
Message-ID: <1330978399-32081-1-git-send-email-sathisha.nanjappa@hp.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:40082 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603Ab2CEUNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Mar 2012 15:13:32 -0500
Received: from g1t0039.austin.hp.com (g1t0039.austin.hp.com [16.236.32.45])
	by g1t0029.austin.hp.com (Postfix) with ESMTP id E8BF53808F
	for <linux-scsi@vger.kernel.org>; Mon,  5 Mar 2012 20:13:31 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathisha Nanjappa <sathisha.nanjappa@hp.com>

Minor change to weed out the intended loginfo messages. 

Sathisha Nanjappa (1):
  Corrected the constant in comparison to a hexadecimal.

 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
1.7.7.6

