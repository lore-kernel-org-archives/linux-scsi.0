From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/5] scsi_debug: fix invalid value check for guard module parameter
Date: Fri, 20 Sep 2013 18:23:35 -0400
Message-ID: <yq1wqmbdteg.fsf@sermon.lab.mkp.net>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
	<1379507248-15929-5-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29612 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITWXp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:23:45 -0400
In-Reply-To: <1379507248-15929-5-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Wed, 18 Sep 2013 21:27:27 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, Joe Perches <joe@perches.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> In the module initialization, invalid value for guard module
Akinobu> parameter is detected by the following check:

Akinobu>         if (scsi_debug_guard > 1) {
Akinobu>                 printk(KERN_ERR "scsi_debug_init: guard must be
Akinobu>                 0 or 1\n"); return -EINVAL;
Akinobu>         }

Akinobu> But this check isn't enough, because the type of
Akinobu> scsi_debug_guard is 'int' and scsi_debug_guard could be a
Akinobu> negative value.

Akinobu> This fixes it by changing the type of scsi_debug_guard to
Akinobu> 'unsigned int' instead of adding extra check for a negative
Akinobu> value.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
