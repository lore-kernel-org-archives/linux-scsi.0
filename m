From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: mpt2sas and mpt3sas merge (again)
Date: Mon, 14 Jul 2014 19:00:27 +0200
Message-ID: <53C40CAB.6020807@redhat.com>
References: <20140714083547.GA6315@infradead.org> <53C3A170.1070101@suse.de>	 <1405347425.2395.5.camel@dabdike.int.hansenpartnership.com>	 <53C3EB99.5040205@suse.de> <1405349824.2395.9.camel@dabdike.int.hansenpartnership.com> <53C3F2E0.3000702@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506AbaGNRA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2014 13:00:58 -0400
In-Reply-To: <53C3F2E0.3000702@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-scsi@vger.kernel.org, Tom Coughlan <coughlan@redhat.com>

On 07/14/2014 05:10 PM, Hannes Reinecke wrote:
> On 07/14/2014 04:57 PM, James Bottomley wrote:
>> On Mon, 2014-07-14 at 16:39 +0200, Hannes Reinecke wrote:
>>> On 07/14/2014 04:17 PM, James Bottomley wrote:
> [ .. ]
>>>> This isn't really a democracy; it's about who maintains the drivers and
>>>> right now it's LSI (or whatever their new name is).
>>>>
>>>> One of the big reasons we don't have a lot of leverage with them is that
>>>> they always seem to slide updates around upstream via the distros
>>>> (often,  it has to be admitted the DKM route), so if Red Hat, SUSE,
>>>> Oracle and Canonical can agree not to accept LSI updates until the
>>>> driver is done this way, we'd have a lot more leverage.

We have a strong 'upstream first' policy in our releases for new drivers
and for new patches, so in theory upstream could use the force, I still  prefer
a softer way that is discussing it with Avago(LSI) and getting their ack. 

>>>>
>>> Hmm. We (as SUSE) have been striving to have a 'upstream first'
>>> policy. IE for any new release the drivers have to be upstream
>>> before we consider including it in our release.
>>> This is most certainly true for the upcoming SLE-12 release, and
>>> also has been enforced for the current SLES11 SP3 release.
>>>
>>> This is official company policy, and has been communicated to all
>>> our partners.
>>> We do accept driver updates (ie patches which are not upstream ATM),
>>> but only on the understanding that the vendor will have to push the
>>> patches upstream eventually.
>>> If they don't the patches will be kicked out of the next release.
>>> (Which is what happened to the mptsas v4 release; it never made it
>>> upstream and so got dropped from SLE-12).
>>>
>>> However, this cuts both ways; we cannot go and tell our partners to
>>> change the driver if upstream hasn't done it first.
>> I'm not saying we need to go into why this happened.  Just that I'd like
>> community agreement amongst the distros before trying to force the
>> issue.  I accept that the distros respond to their TAMs as well as the
>> community, but if there's going to be TAM push back, I'd at least like
>> to hear about it so I can have a word with the relevant people.
>>
>>> So the push has to come from us (as the linux kernel developers);
>>> after all, we should make the decision what goes in and what
>>> doesn't. If a driver is in a bad state (and it's actually us which
>>> defines the 'bad state') we should be discussing on how we would
>>> like to improve things.
>>> If the maintainer proves unwilling to implement our suggestions we
>>> can always go ahead and implement a separate driver.
>> Then we need a maintainer of that driver ... remember this is a fat
>> firmware driver with a proprietary interface.  It's hard to maintain and
>> update without docs ... unless you happen to have an NDA copy?
>>
> Hmm. _if_ the driver is similar to the original one (which was the 
> idea) it should be reasonably trivial to port the latest changes 
> from the original driver to the merged one.

I think you expect more or less that after that new driver is created it
will be maintained again by Avago(LSI), so let us hear what they think first.


>From my point of view the not optimal thing already has happened, both driver exist
and both are included in our major releases.
 
The change is probably better for the long-term maintainability of the driver,
but from the distro perspective any switch to a new driver adds some new work,
because we don't want to remove any particular old driver which has been included to
a major release. 
That said, I agree that we (Red Hat) will manage the change, since it is the better
approach for the long-term maintenance of the driver in the upstream". 

Cheers,
Tomas

>
>>> Look what happened to hpsa; this was the pretty much the showcase on
>>> how it should be done:
>>> Tomo went ahead and re-implemented the cciss driver, and eventually
>>> HP adopted it as their main driver.
>>> I agree that was pretty much the optimal case, though:-)
>> The best is to get LSI to agree, yes ... hence the need for unanimity.
>>
> Agreed. Let's see what LSI has to say here.
>
> Cheers,
>
> Hannes

