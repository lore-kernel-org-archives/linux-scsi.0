From: Hannes Reinecke <hare@suse.de>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 17:10:24 +0200
Message-ID: <53C3F2E0.3000702@suse.de>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de>	 <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>	 <53C3EB99.5040205@suse.de> <1405349824.2395.9.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbaGNPK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 11:10:28 -0400
In-Reply-To: <1405349824.2395.9.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-scsi@vger.kernel.org

On 07/14/2014 04:57 PM, James Bottomley wrote:
> On Mon, 2014-07-14 at 16:39 +0200, Hannes Reinecke wrote:
>> On 07/14/2014 04:17 PM, James Bottomley wrote:
[ .. ]
>>>
>>> This isn't really a democracy; it's about who maintains the drivers=
 and
>>> right now it's LSI (or whatever their new name is).
>>>
>>> One of the big reasons we don't have a lot of leverage with them is=
 that
>>> they always seem to slide updates around upstream via the distros
>>> (often,  it has to be admitted the DKM route), so if Red Hat, SUSE,
>>> Oracle and Canonical can agree not to accept LSI updates until the
>>> driver is done this way, we'd have a lot more leverage.
>>>
>> Hmm. We (as SUSE) have been striving to have a 'upstream first'
>> policy. IE for any new release the drivers have to be upstream
>> before we consider including it in our release.
>> This is most certainly true for the upcoming SLE-12 release, and
>> also has been enforced for the current SLES11 SP3 release.
>>
>> This is official company policy, and has been communicated to all
>> our partners.
>> We do accept driver updates (ie patches which are not upstream ATM),
>> but only on the understanding that the vendor will have to push the
>> patches upstream eventually.
>> If they don't the patches will be kicked out of the next release.
>> (Which is what happened to the mptsas v4 release; it never made it
>> upstream and so got dropped from SLE-12).
>>
>> However, this cuts both ways; we cannot go and tell our partners to
>> change the driver if upstream hasn't done it first.
>
> I'm not saying we need to go into why this happened.  Just that I'd l=
ike
> community agreement amongst the distros before trying to force the
> issue.  I accept that the distros respond to their TAMs as well as th=
e
> community, but if there's going to be TAM push back, I'd at least lik=
e
> to hear about it so I can have a word with the relevant people.
>
>> So the push has to come from us (as the linux kernel developers);
>> after all, we should make the decision what goes in and what
>> doesn't. If a driver is in a bad state (and it's actually us which
>> defines the 'bad state') we should be discussing on how we would
>> like to improve things.
>> If the maintainer proves unwilling to implement our suggestions we
>> can always go ahead and implement a separate driver.
>
> Then we need a maintainer of that driver ... remember this is a fat
> firmware driver with a proprietary interface.  It's hard to maintain =
and
> update without docs ... unless you happen to have an NDA copy?
>
Hmm. _if_ the driver is similar to the original one (which was the=20
idea) it should be reasonably trivial to port the latest changes=20
from the original driver to the merged one.

>> Look what happened to hpsa; this was the pretty much the showcase on
>> how it should be done:
>> Tomo went ahead and re-implemented the cciss driver, and eventually
>> HP adopted it as their main driver.
>> I agree that was pretty much the optimal case, though:-)
>
> The best is to get LSI to agree, yes ... hence the need for unanimity=
=2E
>
Agreed. Let's see what LSI has to say here.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
