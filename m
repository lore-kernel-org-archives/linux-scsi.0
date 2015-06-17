From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] [PATCH] block: Add blk_max_rw_sectors limit
Date: Wed, 17 Jun 2015 08:26:50 -0500
Message-ID: <5581759A.4080009@linux.vnet.ibm.com>
References: <201506151902.t5FJ2giY001071@d01av01.pok.ibm.com> <yq1616nff0p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:58597 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbbFQN0z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2015 09:26:55 -0400
Received: from /spool/local
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 17 Jun 2015 09:26:55 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id DE3F6C90041
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2015 09:17:59 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5HDQrPU54395092
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2015 13:26:53 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5HDQq8a001446
	for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2015 09:26:52 -0400
In-Reply-To: <yq1616nff0p.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, hch@infradead.org, axboe@kernel.dk

On 06/16/2015 05:46 PM, Martin K. Petersen wrote:
> 
> Brian,
> 
> I only have minor nits wrt. your patch since you did what I asked.
> However, now that I'm less jet lagged and blurry eyed I wonder if
> the tweak below wouldn't suffice?

Works for me. Thanks!

Tested-by: Brian King <brking@linux.vnet.ibm.com>

-Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


