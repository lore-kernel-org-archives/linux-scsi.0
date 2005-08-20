From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sat, 20 Aug 2005 13:34:49 -0400
Message-ID: <430769B9.9080302@adaptec.com>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A3A@xbl3.ma.emulex.com> <4304DBA1.4050900@pobox.com> <20050819140631.GB12485@lst.de> <43061C3C.2020303@adaptec.com> <20050819175459.GA16619@lst.de> <43061D57.9060201@adaptec.com> <20050819175929.GA5614@infradead.org> <43061FC9.8060301@adaptec.com> <1124481582.5130.88.camel@mulgrave> <430641CF.3070709@adaptec.com> <20050820091814.GB21698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:62372 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932590AbVHTRe4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Aug 2005 13:34:56 -0400
In-Reply-To: <20050820091814.GB21698@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jejb@steeleye.com>, Jeff Garzik <jgarzik@pobox.com>, James.Smart@Emulex.Com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On 08/20/05 05:18, Christoph Hellwig wrote:
> On Fri, Aug 19, 2005 at 04:32:15PM -0400, Luben Tuikov wrote:
> 
>>>The current SAS class will only get validated when it actually meets
>>>real SAS topologies, which is acceptable in my view just to get this
>>>project actually moving; code can always be updated later ...
>>
>>James, the "current SAS class" _will_go_ into the kernel because:
>>	- It is 3 vendor driven: LSI, Dell, HP.
>>	- It is being developed by you and Christoph, the people
>>who decide what goes in or not.
> 
> 
> No, it will go in because it's the only class actually available.
> 
> I'd still love to see any code from you posted publically.  I've been
> forwarded in private some code you sent around to a few people at OLS,

Thats good, I was hoping that you'd get it.

> but you still can't be bothered to actually posting it publically.  Not

C'mon Christoph -- no one more than me wants to see SCSI Core improved.
5 years ago because of iSCSI, now because of SAS.

It's not about "being bothered", it's just that it's not quite
finished yet.

> that even if my minimal code goes in now there's absolutely no reason
> we can't replace it completely later on.  See the evolution of the FC
> transport class.

Who makes all those decisions?

More generally, why is SCSI Core not being managed by
Documentation/ManagingStyle?

Is it because there's so much vendor interest here?

	Luben



