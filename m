From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Limit number of integrity segments
Date: Fri, 10 Sep 2010 14:52:24 +0200
Message-ID: <20100910125224.GA13211@schmichrtp.mainz.de.ibm.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
 <4C8A1EB3.7020101@fusionio.com>
 <yq1k4mtrcso.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39360 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab0IJMw2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 08:52:28 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.1/8.13.1) with ESMTP id o8ACqQAA005929
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 12:52:26 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8ACqP4M3129374
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 14:52:26 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o8ACqPBS014560
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 14:52:25 +0200
Content-Disposition: inline
In-Reply-To: <yq1k4mtrcso.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Sep 10, 2010 at 08:41:27AM -0400, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> So this is a bug and we want to fix it, but it's not a strict
> Jens> regression against earlier releases. So based on that .37 should
> Jens> be fine. But there's definitely some reasons for shoving it into
> Jens> .35 as well. What was your intention?
> 
> I was aiming at 2.6.37 since it's a pretty big change to wedge in this
> late in the .36 cycle.  And the zfcp DIX support is only experimental.
> 
> But that's really Christof's call.  My concern wrt. 2.6.36 is purely
> process-related, I don't have any technical objections.

It is a missing piece for the experimental DIX support in zfcp. Since
we tell everybody that it is "experimental", merging the patches only
for 2.6.37 is fine for me.

--
Christof
