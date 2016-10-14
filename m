From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch] zfcp: spin_lock_irqsave() is not nestable
Date: Fri, 14 Oct 2016 16:21:02 -0400
Message-ID: <yq11szilm1d.fsf@sermon.lab.mkp.net>
References: <20161013085358.GH16198@mwanda>
        <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:47258 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757096AbcJNUWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2016 16:22:43 -0400
In-Reply-To: <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
        (Steffen Maier's message of "Thu, 13 Oct 2016 12:49:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Hendrik =?utf-8?Q?Br=C3=BCckner?= <brueckner@linux.vnet.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>

>>>>> "Steffen" == Steffen Maier <maier@linux.vnet.ibm.com> writes:

Steffen> could you please queue this as fix for one of my patches that
Steffen> went into the 4.9 merge window, so for 4.9-rc I guess?

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
