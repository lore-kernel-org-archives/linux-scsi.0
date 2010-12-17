From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Fri, 17 Dec 2010 22:47:12 +0300
Message-ID: <4D0BBE40.6030000@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>	 <1292599364.2820.21.camel@mulgrave.site>  <4D0B8975.1040206@vlnb.net> <1292602908.2820.41.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292602908.2820.41.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley, on 12/17/2010 07:21 PM wrote:
> On Fri, 2010-12-17 at 19:01 +0300, Vladislav Bolkhovitin wrote:
>> James Bottomley, on 12/17/2010 06:22 PM wrote:
>>> OK, I think this has reached the stage where it's been polished enough
>>> outside mainline to the point where we can complete any remaining todo
>>> items in-tree.
>>>
>>> So lets begin merging with the minimal target core and the TCM_Loop as
>>> two separate commits. I think the target core may just fit under the
>>> reflector mail length limits, but if not, you can send it as multiple
>>> patches and I'll recombine them.
>>
>> Well, could somebody eventually explain what are advantages of LIO over
>> SCST so you are choosing it?
>>
>> LIO is obviously worse all technically (see
>> http://scst.sourceforge.net/comparison.html) as well as in the number of
>> users and size of the community. Current in-rush attempts to make LIO
>> _look_ not worse than SCST changed nothing in this area.
> 
> To be honest, I don't really give a toss about niche feature
> comparisons: both products have niche features the other doesn't.  The
> basic requirements in both products are solid.

James, sorry, but your position is weak and absurd. In it maturity,
quality and features don't matter. Following this logic Linux kernel and
a student's home brewed OS kernel for his PhD work are equal. Obviously,
this is wrong. No doubts, that all what Linux kernel can do with the
same quality as it does can be added to the student's kernel sooner or
later, ... but after several decades of hard work of thousands of people.

Moreover, isn't Linux kernel and you as a maintainer supposed to choose
what is ALREADY the best, not what is promising to become better
somewhen in the future? Or not become.

> If the niche feature has
> customer value, my estimation is that it can easily be added (to either
> product).

If you eventually look on the technical comparison of SCST and LIO,
you'll see that SCST is far ahead in practically everywhere, in any
major area. Why not to compare yourself instead of blindly relying on
what NicholasB and his people are chea^H^H^H^Hsaying.

>> In the resent threads how many people voted for LIO? Nobody. How many
>> for SCST? Many. Moreover, has any real user of LIO participated in those
>> threads? None?
> 
> This isn't a democracy ... it's about choosing the most community
> oriented code base so that it's easily maintainable and easy to add
> feature requests and improvements as and when they come along.  In the
> past six months, LIO has made genuine efforts to clean up its act,
> streamline its code and support the other community projects that would
> need to go above and around it.

At first, can you recall any cases where community comments to SCST were
not addressed? All of them have been addressed and none ignored. NEVER.

Simply, LIO is very much premature code comparing to SCST. It is very
easy to find in it simple issues to comment, hence you see the big value
of comments.

In contrast, SCST has been maturing for many years (since 2004). It's
polished to high finish, so you can't so easily find out something to
improve in it. The feature requests and improvements in LIO you are
referring simply already in SCST.

Also, doesn't the size of the community reflects how community oriented
project is?

So far in the kernel community we see that, basically, the only person,
Christoph Hellwig, has taken responsibility to judge and he is pushing
LIO. Christoph is a very authoritative person, so many people are just
following his direction not dare to object. Nobody wants to go against
Christoph Hellwig. At max, people sending me private support e-mails
(thanks!) writing that SCST is great and obviously receives very unfair
treatment from the kernel maintainers.

But Christoph is a biased person. Several years ago he preferred
blessing STGT creation instead of already well existing at that moment
SCST. Now we know that was a wrong move and SCST was the right way to go.

Are we going to repeat that mistake again?

> You seem to have spent a lot of the
> intervening time arguing with the sysfs maintainer about why you're
> right and he's wrong.

Well, we are making the best designed and implemented code, right?
Aren't arguments part of this process?

Anyway, we almost finished a patch with new SCST sysfs interface, which
should satisfy Greg KH requirements. Bart several days ago sent proposed
new layout and Greg didn't object to it. We will send this patch in
several days.

Vlad
