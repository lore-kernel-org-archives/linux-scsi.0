From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] scsi_debug: fix false positive logical block reference tag check fail
Date: Fri, 10 Jan 2014 16:32:42 -0500
Message-ID: <yq1fvovplol.fsf@sermon.lab.mkp.net>
References: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
	<1388964792-3546-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:49176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJVcs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 16:32:48 -0500
In-Reply-To: <1388964792-3546-2-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Mon, 6 Jan 2014 08:33:07 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <JBottomley@Parallels.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> Reading partially unwritten sectors generates a false positive
Akinobu> logical block reference tag check failure when DIF is enabled.

Akinobu> This bug is caused by missing ei_lba increment in loop of
Akinobu> dif_verify() when unwritten sector is skipped.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
