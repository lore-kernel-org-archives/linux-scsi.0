From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 5/6] scsi_debug: prepare to enable clustering
Date: Fri, 10 Jan 2014 16:41:47 -0500
Message-ID: <yq1bnzjpl9g.fsf@sermon.lab.mkp.net>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
	<1388964792-3546-6-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17166 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaAJVl4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 16:41:56 -0500
In-Reply-To: <1388964792-3546-6-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 6 Jan 2014 08:33:11 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> This replaces these for_each_sg() loops with sg mapping
Akinobu> iterator which is capable of handling each sg list element is
Akinobu> consisted with multiple pages.

Looks good in general but what's with disabling interrupts? Would it be
better to move the PI verification in under atomic_rw?

-- 
Martin K. Petersen	Oracle Linux Engineering
