From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/5] scsi_debug: fix buffer overrun when DIF/DIX is enabled and virtual_gb > 0
Date: Fri, 20 Sep 2013 18:13:57 -0400
Message-ID: <yq1a9j7f8ey.fsf@sermon.lab.mkp.net>
References: <1379507248-15929-1-git-send-email-akinobu.mita@gmail.com>
	<1379507248-15929-2-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27025 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab3ITWOH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2013 18:14:07 -0400
In-Reply-To: <1379507248-15929-2-git-send-email-akinobu.mita@gmail.com>
	(Akinobu Mita's message of "Wed, 18 Sep 2013 21:27:24 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:

Akinobu> If the module parameter virtual_gb is greater than 0, the READ
Akinobu> command may request the blocks which exceed actual ramdisk
Akinobu> storage (fake_storep).  prot_verify_read() should treat those
Akinobu> blocks as wrap around the end of fake_storep.  But it actually
Akinobu> causes fake_storep and dif_storep buffer overruns.

Akinobu> This fixes these buffer overruns.  In order to simplify the
Akinobu> fix, this also introduces fake_store() and dif_store() which
Akinobu> return corresponding wrap around addresses.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
