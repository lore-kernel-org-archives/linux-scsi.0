From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Fri, 29 Feb 2008 00:46:06 +0900
Message-ID: <47C6D73E.4030302@gmail.com>
References: <1203839683.17463.9.camel@homer.simson.net> <1204019283.8731.11.camel@homer.simson.net> <1204033003.11828.22.camel@homer.simson.net> <20080226150845.2196bc1a.akpm@linux-foundation.org> <1204079075.26640.8.camel@homer.simson.net> <1204092010.9934.31.camel@homer.simson.net> <1204096025.1623.9.camel@homer.simson.net> <47C6661E.9010504@gmail.com> <1204186800.7362.7.camel@homer.simson.net> <47C675C6.8000904@gmail.com> <20080228153542.GZ6704@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:47419 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758509AbYB1PqR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Feb 2008 10:46:17 -0500
Received: by ik-out-1112.google.com with SMTP id c28so1627994ika.5
        for <linux-scsi@vger.kernel.org>; Thu, 28 Feb 2008 07:46:15 -0800 (PST)
In-Reply-To: <20080228153542.GZ6704@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mike Galbraith <efault@gmx.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>

Jens Axboe wrote:
>> This problem was reported and diagnosed by Mike Galbraith.
> 
> Tejun, this patch isn't much cleaner at all. It really shows the pain of
> these two seperate, yet related, variables.

Not much cleaner compared to what?  I think padding stuff is bound to be
somewhat complex.  It's a nasty thing in nature.  I think ->extra_len is
better than ->raw_data_len because ->extra_len only needs to be updated
where the dirty jobs are done and extra buffer areas are added.  Any
better suggestions?

Thanks.

-- 
tejun
