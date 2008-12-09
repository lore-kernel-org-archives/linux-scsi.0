From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Correctly release and allocate a new request upon retries
Date: Tue, 9 Dec 2008 15:51:19 +0100
Message-ID: <20081209145119.GA23742@kernel.dk>
References: <493D2E05.3070108@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:1390 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYLIOvd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Dec 2008 09:51:33 -0500
Content-Disposition: inline
In-Reply-To: <493D2E05.3070108@hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, LKML-scsi <linux-scsi@vger.kernel.org>

On Mon, Dec 08 2008, Alan D. Brunelle wrote:

> Commands needing to be retried require a complete re-initialization.
> 
> The test-unit-ready portion of this patch was causing boots to fail on
> my test machine (as in http://lkml.org/lkml/2008/12/5/161). With this
> patch in place, the system is booting reliably.
> 
> Mike Anderson found the same problem in the hp_hw_start_stop code,
> and I applied the same solution in cdrom_read_cdda_bpc.

Thanks Alan, applied for 2.6.28.

-- 
Jens Axboe

