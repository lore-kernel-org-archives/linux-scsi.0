From: Liran Schour <LIRANS@il.ibm.com>
Subject: SCSI commands order when using scsi_do_req
Date: Thu, 2 Jun 2005 20:31:15 +0300
Message-ID: <OFE0914CA0.DA8D0415-ONC2257014.004F2855-C2257014.00603EFB@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:7874 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261208AbVFBRfX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Jun 2005 13:35:23 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j52HZM1c160738
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 17:35:22 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j52HZMDo150770
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 19:35:22 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j52HZMko015179
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 19:35:22 +0200
Received: from d12ml102.megacenter.de.ibm.com (d12ml102.megacenter.de.ibm.com [9.149.166.138])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j52HZL1e015176
	for <linux-scsi@vger.kernel.org>; Thu, 2 Jun 2005 19:35:22 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





I am developing a new SCSI upper layer driver. (Object based SCSI device)
I noticed that scsi_do_req execute commands in LIFO order (add new commands
to the head of the Q).
This behavior can cause a starvation of commands (or at least long delays).
What is the proper solution to this?

Thanks,
- Liran

