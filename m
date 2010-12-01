From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: block: Deprecate QUEUE_FLAG_CLUSTER and use queue_limits instead
Date: Wed, 1 Dec 2010 19:43:36 +0100
Message-ID: <4CF69758.40900@fusionio.com>
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4EB8@nonamew.ptu.promise.com>	<yq14ob5o2d4.fsf@sermon.lab.mkp.net>	<yq1vd3lmkdt.fsf_-_@sermon.lab.mkp.net>	<4CEEAE35.5060805@fusionio.com> <yq1r5e8ncmz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:37826 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882Ab0LASnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Dec 2010 13:43:41 -0500
In-Reply-To: <yq1r5e8ncmz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Promise_Linux <Promise_Linux@promise.com>

On 2010-11-26 01:37, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> Great, the two different values and needing to sync them was
> Jens> horrible.  What kind of testing did you do? Have to be a little
> Jens> extra careful at this point.
> 
> Yeah, we should probably let it soak a bit in -next just to make sure.
> 
> There really aren't many devices from this millennium that don't support
> clustering. Which I guess is why we haven't seen any problems.
> 
> I ended up disabling clustering in one of the FC drivers to test with a
> real workload. Threw in a BUG_ON(nsegs > queue_max_segments(q)) for good
> measure.
> 
> I also tested mixing and matching clustered and non-clustered bottom
> devices while stacking with DM.
> 
> New version below, fixing the things you and Matthew pointed out...

Thanks applied. Small plea for the future - please rewrite the subject
line to indicate a v2 (or whatever) of the patch. That will make them
harder to miss.

-- 
Jens Axboe

