From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/5] scsi_debug: factor out copying PI from dif_storep to prot_sglist
Date: Fri, 20 Sep 2013 18:20:56 -0400
Message-ID: <yq161tvf83b.fsf@sermon.lab.mkp.net>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
	<1379507248-15929-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28929 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab3ITWVF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:21:05 -0400
In-Reply-To: <1379507248-15929-3-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Wed, 18 Sep 2013 21:27:25 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> If data integrity support is enabled, prot_verify_read() is
Akinobu> called in response to READ commands and it verifies protection
Akinobu> info from dif_storep by comparing against fake_storep, and
Akinobu> copies protection info to prot_sglist.

Akinobu> This factors out the portion of copying protection info into a
Akinobu> separate function.  It will also be reused in the next change
Akinobu> after supporting the opposite direction (copying prot_sglist to
Akinobu> dif_storep).

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
