From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/6] scsi_debug: fix duplicate dif_errors increment
Date: Fri, 10 Jan 2014 16:30:27 -0500
Message-ID: <yq1k3e7plsc.fsf@sermon.lab.mkp.net>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
	<1388964792-3546-4-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48336 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaAJVaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 16:30:39 -0500
In-Reply-To: <1388964792-3546-4-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 6 Jan 2014 08:33:09 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> It is unnecessary to increase dif_errors in dif_verify(),
Akinobu> because the caller will increment it when dif_verify() detects
Akinobu> failure.

Akinobu> This bug was introduced by commit beb40ea42bd6 ("[SCSI]
Akinobu> scsi_debug: reduce duplication between prot_verify_read and
Akinobu> prot_verify_write")

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
