From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Limit number of integrity segments
Date: Fri, 10 Sep 2010 08:41:27 -0400
Message-ID: <yq1k4mtrcso.fsf@sermon.lab.mkp.net>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com>
	<4C8A1EB3.7020101@fusionio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:47792 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0IJMmi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 08:42:38 -0400
In-Reply-To: <4C8A1EB3.7020101@fusionio.com> (Jens Axboe's message of "Fri, 10
	Sep 2010 14:04:03 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "christof.schmitt@de.ibm.com" <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:

Jens> So this is a bug and we want to fix it, but it's not a strict
Jens> regression against earlier releases. So based on that .37 should
Jens> be fine. But there's definitely some reasons for shoving it into
Jens> .35 as well. What was your intention?

I was aiming at 2.6.37 since it's a pretty big change to wedge in this
late in the .36 cycle.  And the zfcp DIX support is only experimental.

But that's really Christof's call.  My concern wrt. 2.6.36 is purely
process-related, I don't have any technical objections.

-- 
Martin K. Petersen	Oracle Linux Engineering
