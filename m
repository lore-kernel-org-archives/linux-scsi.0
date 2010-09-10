From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Limit number of integrity segments
Date: Fri, 10 Sep 2010 14:04:03 +0200
Message-ID: <4C8A1EB3.7020101@fusionio.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48795 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0IJMEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 08:04:06 -0400
In-Reply-To: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "christof.schmitt@de.ibm.com" <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-10 07:32, Martin K. Petersen wrote:
> 
> [My script defaulted to Jens' old address.  Sorry about the repost]
> 
> First patch moves min_not_zero() to kernel.h.  It's currently defined
> several places throughout the block layer and I was about to introduce
> another instance.  So let's make this generic.
> 
> Second patch works around the limitations in the zfcp hardware by
> introducing a limit on the number of integrity scatterlist elements.
> Christof will post a separate patch that updates the zfcp driver to take
> advantage of this.
> 
> I'd prefer we if could feed everything, including the SCSI changes,
> through the block tree.  I have had to change some existing interfaces
> so a post-merge tree will not cut it and compatibility wrappers seem
> like an overkill for this.

So this is a bug and we want to fix it, but it's not a strict
regression against earlier releases. So based on that .37 should
be fine. But there's definitely some reasons for shoving it into
.35 as well. What was your intention?

-- 
Jens Axboe

