From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: Re: fastfail operation and retries
Date: Wed, 20 Apr 2005 10:10:59 +0200
Message-ID: <OF6A9F67A4.5AB6B6C0-ONC1256FE9.002CC792-C1256FE9.002D0981@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.29.150]:28579 "EHLO
	mtagate1.de.ibm.com") by vger.kernel.org with ESMTP id S261481AbVDTILB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Apr 2005 04:11:01 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate1.de.ibm.com (8.12.10/8.12.10) with ESMTP id j3K8B00Q119854
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 08:11:00 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3K8B0n8277734
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:11:00 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j3K8B0Bs001254
	for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2005 10:11:00 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?GB2312?B?08nUqM+8?= <yxyou@yahoo.com.cn>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

        ??? <yxyou@yahoo.com.cn> wrote:
        20.04.2005 03:17
 
> what multipath are you using? Software, or hardware,
> or both?

We are using udm with evms (Linux on zSeries).
Hardware setup is:
- switched fabric FC-SAN,
- 4 paths to each FC-LUN on the ESS 800

All 4 paths are "failing fast" during operations on
the ESS and our stress test tool encounteres I/O-errors.


Regards,

Andreas

