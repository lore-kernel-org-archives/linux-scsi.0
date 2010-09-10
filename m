From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Limit number of integrity segments
Date: Fri, 10 Sep 2010 15:01:06 +0200
Message-ID: <4C8A2C12.5030509@fusionio.com>
References: <1284096730-13147-1-git-send-email-martin.petersen@oracle.com> <4C8A1EB3.7020101@fusionio.com> <yq1k4mtrcso.fsf@sermon.lab.mkp.net> <20100910125224.GA13211@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35558 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726Ab0IJNBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2010 09:01:09 -0400
In-Reply-To: <20100910125224.GA13211@schmichrtp.mainz.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-10 14:52, Christof Schmitt wrote:
> On Fri, Sep 10, 2010 at 08:41:27AM -0400, Martin K. Petersen wrote:
>>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
>>
>> Jens> So this is a bug and we want to fix it, but it's not a strict
>> Jens> regression against earlier releases. So based on that .37 should
>> Jens> be fine. But there's definitely some reasons for shoving it into
>> Jens> .35 as well. What was your intention?
>>
>> I was aiming at 2.6.37 since it's a pretty big change to wedge in this
>> late in the .36 cycle.  And the zfcp DIX support is only experimental.
>>
>> But that's really Christof's call.  My concern wrt. 2.6.36 is purely
>> process-related, I don't have any technical objections.
> 
> It is a missing piece for the experimental DIX support in zfcp. Since
> we tell everybody that it is "experimental", merging the patches only
> for 2.6.37 is fine for me.

Great, I'll queue it up for 2.6.37.

-- 
Jens Axboe

