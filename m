From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
Date: Tue, 24 Aug 2010 23:53:14 +0400
Message-ID: <4C74232A.9070507@vlnb.net>
References: <4C69653E.6050808@vlnb.net>	 <1282077040.16098.47.camel@mulgrave.site> <4C6C1DC1.8090208@vlnb.net>	 <1282164188.10878.22.camel@mulgrave.site> <4C702030.2070306@vlnb.net>	 <1282423128.3015.35.camel@mulgrave.site>	 <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>	 <1282582740.11194.17.camel@mulgrave.site>  <4C72CEC5.4080204@vlnb.net> <1282595927.11194.78.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0HXTxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2010 15:53:09 -0400
In-Reply-To: <1282595927.11194.78.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Gennadiy Nerubayev <parakie@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley, on 08/24/2010 12:38 AM wrote:
> On Mon, 2010-08-23 at 23:40 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley, on 08/23/2010 08:59 PM wrote:
>>> My basic conclusion was that there's no incredible discriminator between
>>> LIO and STGT (although there are reams written on which performs better
>>> in which circumsances, is useful for clustering, supports ALUA, etc.
>>> each with partisans for the features).
>>
>> Here is a comprehensive features comparison I prepared some time ago:
>> http://scst.sourceforge.net/comparison.html. It's a bit outdated at the
>> moment, but I'm going to make it completely up do date in the next few days.
>
> That's not really going to help ... I don't really want another 500 mail
> thread of partisan yelling about which is better.  I'm happy to concede
> that either could beat the other on a given set of well chosen tests ...
> but knowing that is completely useless to me.  I can also guess, given
> the antipathy, that neither of you would agree on a definitive set of
> comparison tests.

Hmm, the comparison page isn't supposed to contain a set of tests which 
one implementation can pass or another. It is supposed to help reviewing 
different implementations and give a reviewer a clue where to look to 
see the difference. I believe that for such highly experienced person 
like you it wouldn't take much effort to find the corresponding code and 
verify it.

For instance, if it comes for you or someone other to choose the best 
target, what criteria would you use? I hope, a technical review would be 
the first criteria.

Regarding tests. Definitely, it is a very attractive idea to have an 
ultimate test or a set of tests to just run them and everything becomes 
obvious. But, unfortunately, you know, effort to implement such tests is 
comparable with effort to implement the features those tests are 
testing. But, on my side, I'm willing to run any test you like.

> So it comes down to a community test instead: which works better with
> the community.  This is important to me because it's an indication of
> what might ensue once code goes upstream and thus moves outside the
> exclusive province of the project to become a community resource. STGT
> is a community too and so far what you seem to have told me is:
>
>        * STGT users should just migrate to scst_local
>        * STGT doesn't have enough users to bother with
>        * STGT has fundamental design flaws which makes its pass through
>          architecture unusable and its ABI flawed.

Small correction (although it doesn't matter):

  - The pass through architecture of STGT isn't unusable, it only 
doesn't implement all it is needed for correct SCSI-confirming way to 
provide 1 to many relationship and fundamentally can't do that 
effectively for simultaneous remote and local access from the target via 
sg/st/etc.

  - The ABI (architecture, actually, which it serves) is flawed in the 
performance side, because it doesn't allow to achieve better performance 
than it currently has.

> I'm sure STGT appreciates the frank assessments, but it doesn't seem to
> merit too many "plays well with others" points.

I agree with you, but if you were me, what would you do? You know how 
STGT was started. At that time SCST already was in a good shape with a 
users base. But after private SCST evaluation completely behind my back 
based on misunderstandings and incorrect assumptions STGT was invented 
by the STGT developers. Nobody asked me anything. If at that time I had 
been asked to clarify the tasks SCST is solving and why it is solving 
them the chosen ways, it would have saved a lot for the Linux community. 
Then my critics of the chosen approach have just been ignored. So, from 
my POV it rather looks like it is STGT developers who don't want "play 
well with me". And the current situation with the SCSI target agreement 
behind our back only supports that. So, could you advice how we can go 
away from the current situation?

I have always open for cooperation. If I wrong in my critics (which is 
always constructive, BTW) I welcome everyone to disagree with me and 
tell me where I'm wrong.

(English isn't my native language, so sometimes I may be not quite 
emotionally correct and sorry if I unintentionally offended somebody in 
the past or could offend in the future.)

Thanks,
Vlad


