From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Date: Fri, 26 Nov 2010 10:00:13 +0100
Message-ID: <4CEF771D.4010805@fusionio.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com> <yq14ob5o2d4.fsf@sermon.lab.mkp.net> <yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net> <4CEEAE35.5060805@fusionio.com> <yq1r5e8ncmz.fsf@sermon.lab.mkp.net> <20101126022804.GA15662@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:38988 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026Ab0KZJAW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Nov 2010 04:00:22 -0500
In-Reply-To: <20101126022804.GA15662@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Promise_Linux <Promise_Linux@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-11-26 03:28, Mike Snitzer wrote:
> This patch's header could stand to be a bit more explicit about where
> the real problem was ...

Indeed, it seems to miss that. I'll add that bit.

> But I agree that this patch cleans things up nicely.
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks, added.

-- 
Jens Axboe

