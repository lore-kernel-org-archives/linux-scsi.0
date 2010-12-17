From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Sat, 18 Dec 2010 00:35:23 +0300
Message-ID: <4D0BD79B.2010600@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>	 <1292599364.2820.21.camel@mulgrave.site>  <4D0B8975.1040206@vlnb.net>	 <1292602908.2820.41.camel@mulgrave.site>  <4D0BBE40.6030000@vlnb.net> <1292617658.2820.80.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292617658.2820.80.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-scsi@vger.kernel.org


James Bottomley, on 12/17/2010 11:27 PM wrote:
>> James, sorry, but your position is weak and absurd. In it maturity,
>> quality and features don't matter.
> 
> I didn't say maturity and quality, I said niche features.  Apparently
> it's subjective, because both LIO and SCST think their own niche
> features are essential and the other's are irrelevant.

I also meant features. And those features are pretty much objective. See
the comparison page. As I wrote, I'm willing to add to it anything I
missed on the first request. Several month passed and there are no
requests from LIO. So, the page must be complete and accurate.

Although you can't ignore maturity and quality, especially considering
in which rush new features added in LIO in past months.

>From where do you know LIO and SCST are the same level of
maturity/quality? NicholasB told you so?

>> Following this logic Linux kernel and
>> a student's home brewed OS kernel for his PhD work are equal.
> 
> So linux did begin as a student's home brewed OS kernel ...

Does it mean that we should throw away all those decades of work and
start again?

>>  Obviously,
>> this is wrong. No doubts, that all what Linux kernel can do with the
>> same quality as it does can be added to the student's kernel sooner or
>> later, ... but after several decades of hard work of thousands of people.
> 
> Precisely.

Yes, sure. After several decades of hard work of thousands of people.
Not now, when it's ready. We will believe and wait until it's done.

> Or said a different way: as long as you choose the most
> community oriented of competing offerings, the community will fill any
> perceived gaps.  Conversely, you can destroy a project simply by
> alienating the community.  That's why community is more important than
> feature set.

What in the SCST community doesn't satisfy you? It keeps growing, not
"alienating". SCST mailing list has a continual flow of new subscribers
as well as new patches. There are several hundreds messages a month in
it. Many people has been participating for many years.

What's wrong with it?

James, what exactly don't you like in the way how SCST maintained? Tell
us. We are following all the rules we know. But, definitely, you are not
happy with something.

>> At first, can you recall any cases where community comments to SCST were
>> not addressed? All of them have been addressed and none ignored. NEVER.
>>
>> Simply, LIO is very much premature code comparing to SCST. It is very
>> easy to find in it simple issues to comment, hence you see the big value
>> of comments.
> 
> Look, I'm not interested in the backstabbing. *Both* projects have
> fairly large user bases and businesses with revenue models built around
> them, so I see that argument as a wash for both sides.

Me neither interested in backstabbing. But this is precisely what we are
seeing.

NicholasB pleased key people (don't know how he managed to do it,
although suspect), so now you are making absurd arguments trying to
prove that his second grade meat has the first class taste.

Opinions of ones who tried to eat it doesn't matter, because it isn't a
"democracy". From other side you don't want to try yourself, because
NicholasB said the test is perfect, so you believe in it.

Are we in an absurd Kafka novel?

>> Are we going to repeat that mistake again?
> 
> I don't think it was a mistake. STGT gave us the userspace modifiability
> that neither LIO nor STGT offered at the time.

Following your logic, it shouldn't have mattered, right? Because it can
be added to SCST in the future. (LIO didn't even exist at that time.)

But SCST offered user space backend at about time STGT was merged. So,
it isn't too good argument.

What's interesting is that LIO even now doesn't allow it.

Moreover, accepting LIO is against your own rules you declared.
Particularly:

1. It doesn't have user space backend.

2. It exports some information via procfs, which was declared as a big
no-no.

So I keep wondering, why does LIO have so much privileged treatment, so
what was forbidden for SCST allowed for LIO?

Let's treat SCST equally and allow COMMUNITY, not particular BIASED
people to choose the best one!

In this regard it looks to be a good idea to freeze accepting both LIO
and SCST until the end of the next year and then choose one with the
biggest activity in the related mailing lists, not counting me and
NicholasB.

You want the best community, so let community choose!

Vlad
