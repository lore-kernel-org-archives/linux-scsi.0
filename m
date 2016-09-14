From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 3/3] scsi/ncr5380: Improve interrupt latency during PIO tranfers
Date: Wed, 14 Sep 2016 14:12:29 -0400
Message-ID: <yq1twdil59u.fsf@sermon.lab.mkp.net>
References: <20160827022959.303563262@telegraphics.com.au>
        <20160831044453.413698369@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36040 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbcINSMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2016 14:12:40 -0400
In-Reply-To: <20160831044453.413698369@telegraphics.com.au> (Finn Thain's
        message of "Wed, 31 Aug 2016 14:44:56 +1000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

>>>>> "Finn" == Finn Thain <fthain@telegraphics.com.au> writes:

Finn> Large PIO transfers are broken up into chunks to try to avoid
Finn> disabling local IRQs for long periods. But IRQs are still disabled
Finn> for too long and this causes SCC FIFO overruns during serial port
Finn> transfers.

Finn> This patch reduces the PIO chunk size to reduce interrupt latency
Finn> to something on the order of milliseconds, at the expense of
Finn> additional CPU overhead from extra iterations of the
Finn> NCR5380_main() loop.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
