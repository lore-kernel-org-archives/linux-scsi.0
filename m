From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Limit number of integrity segments
Date: Fri, 10 Sep 2010 15:17:06 +0200
Message-ID: <20100910131706.GA17844@schmichrtp.mainz.de.ibm.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
 <4C8A1EB3.7020101@fusionio.com>
 <yq1k4mtrcso.fsf@sermon.lab.mkp.net>
 <20100910125224.GA13211@schmichrtp.mainz.de.ibm.com>
 <4C8A2C12.5030509@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:53317 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0IJNRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 09:17:12 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate4.uk.ibm.com (8.13.1/8.13.1) with ESMTP id o8ADH7Ns016944
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 13:17:07 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o8ADH7mH3264716
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 14:17:07 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o8ADH6qh005242
	for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2010 14:17:07 +0100
Content-Disposition: inline
In-Reply-To: <4C8A2C12.5030509@fusionio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Sep 10, 2010 at 03:01:06PM +0200, Jens Axboe wrote:
> On 2010-09-10 14:52, Christof Schmitt wrote:
> > On Fri, Sep 10, 2010 at 08:41:27AM -0400, Martin K. Petersen wrote:
> >>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> >>
> >> Jens> So this is a bug and we want to fix it, but it's not a strict
> >> Jens> regression against earlier releases. So based on that .37 should
> >> Jens> be fine. But there's definitely some reasons for shoving it into
> >> Jens> .35 as well. What was your intention?
> >>
> >> I was aiming at 2.6.37 since it's a pretty big change to wedge in this
> >> late in the .36 cycle.  And the zfcp DIX support is only experimental.
> >>
> >> But that's really Christof's call.  My concern wrt. 2.6.36 is purely
> >> process-related, I don't have any technical objections.
> > 
> > It is a missing piece for the experimental DIX support in zfcp. Since
> > we tell everybody that it is "experimental", merging the patches only
> > for 2.6.37 is fine for me.
> 
> Great, I'll queue it up for 2.6.37.

Are you picking up the zfcp patch as well?

--
Christof
