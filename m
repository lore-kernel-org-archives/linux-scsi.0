From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] qla2xxx: Indicate out-of-memory with -ENOMEM
Date: Thu, 31 Mar 2016 20:37:55 -0400
Message-ID: <yq1vb42noyk.fsf@sermon.lab.mkp.net>
References: <56FC6049.3090303@sandisk.com> <56FC6061.80403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29410 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbcDAAiJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2016 20:38:09 -0400
In-Reply-To: <56FC6061.80403@sandisk.com> (Bart Van Assche's message of "Wed,
	30 Mar 2016 16:25:21 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> In the Linux kernel it is preferred to return a meaningful error
Bart> code instead of -1. This patch does not change the behavior of the
Bart> caller of qla82xx_pinit_from_rom().

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
