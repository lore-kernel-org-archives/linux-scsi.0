From: Liran Schour <LIRANS@il.ibm.com>
Subject: Support for CDB length > 16
Date: Tue, 18 Nov 2003 10:49:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA910CD2E.7013EC62-ONC2256DE2.002FD991-C2256DE2.00307FFC@il.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:51893 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261763AbTKRIwI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Nov 2003 03:52:08 -0500
Received: from d12relay01.megacenter.de.ibm.com (d12relay01.megacenter.de.ibm.com [9.149.165.180] (may be forged))
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id hAI8pxBs085960
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2003 08:52:00 GMT
Received: from d10ml001.telaviv.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12relay01.megacenter.de.ibm.com (8.12.9/NCO/VER6.6) with ESMTP id hAI8ph9f104750
	for <linux-scsi@vger.kernel.org>; Tue, 18 Nov 2003 09:51:43 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org





Hi all,

I need a support from the Linux SCSI subsystem for CDB length > 16 byte.
Is it possible to do that without recompiling the kernel with a new
MAX_COMMAND_SIZE definition. I assume that I can find an iscsi driver that
is able to support CDB > 16 byte.

Thanks,
- Liran

