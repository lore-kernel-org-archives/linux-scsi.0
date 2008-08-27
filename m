From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Kernel Summit Request for Discussion: The Future of Target mode
 and Cloud storage on Linux
Date: Wed, 27 Aug 2008 22:00:25 +0400
Message-ID: <48B59639.6050802@vlnb.net>
References: <48ADC53B.6090501@vlnb.net>	<20080822081958A.fujita.tomonori@lab.ntt.co.jp>	<48AF0D1F.5030605@vlnb.net> <20080823113624A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-03.mailcluster.net ([77.221.130.215]:35705 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751476AbYH0R7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2008 13:59:54 -0400
In-Reply-To: <20080823113624A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net

FUJITA Tomonori wrote:
>>>>> Hmm, really? STGT development is more active IET.
>>>> Tomo-san, be honest. It was *you*, who stopped the IET development, 
>>>> forcing people to switch to STGT. There is no point to prepare patches 
>>>> for IET, if they will never get merged.
>>> I stopped working on IET but it doesn't mean that I force others to
>>> stop working on IET. Arne said that he merges patches.
>> Well, how about declaring unlimited code freeze for all core parts?
> 
> Why is it difficult for you to understand what I wrote? I wrote again:
> 
> I stopped working on IET but it doesn't mean that I force others to
> stop working on IET.

You stopped working on it, but you didn't stop maintaining it, did you? 
The were neither announcement of it, nor request for somebody else to do 
the maintainership work. So, for everybody you remained the maintainer 
and the only person who can accept or reject patches.

>> Has anybody, except you, had a right to merge patches to IET?
> 
> Nobody asked me to give a right to merge patches to IET. When Arne
> asked me, I was happy to give it him because he has a good knowledge
> of IET code.

Great position! You put yourself as misunderstood. But the problem that 
everybody misunderstood you and it's really hard to believe that you 
wasn't aware of it.

In fact, it was *you* who should have asked about the replacement. It's 
pretty regular practice in Open Source, when people get bored of some 
project and gracefully pass its maintainership to someone other.

>> Which %% of 
>> coming non-trivial patches have you merged in the last few years? Near 
>> zero?
> 
> Probably, near zero because I stopped working on IET. What does 'stop
> working on something' mean for you?
> 
> 
>> For instance, how many not too bad patches from Ross S. W. Walker 
>> were silently ignored? He didn't received even small comments, which 
>> made him so frustrated, so he stopped all the development activities?
> 
> Several days ago on the mailing list, I saw that Ross works on IET
> with Arne.
> 
> 
> I have no idea why you think that you know better than me about the
> project that I had maintained. But can you please stop talking about
> wrong information? I can just ignore your wrong statements (I often
> did) but I don't like to see other people misunderstanding.

This isn't only my impression, this is rather what people using IET 
think. Everyone after digging in IET mailing list archive can find the 
evidences. For instance, see this e-mail: 
http://www.nabble.com/forum/ViewPost.jtp?post=13776875&framed=y
You didn't disprove it, although definitely read, because you replied on 
the later message in that thread. So, what one should think after that 
and after seeing a lot of good patches going to nowhere and only trivial 
ones merged?

> Thanks,
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

