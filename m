From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between different
 SCSI targets (SCST, STGT, IET, LIO) updated
Date: Tue, 07 Sep 2010 01:51:10 +0400
Message-ID: <4C85624E.3090404@vlnb.net>
References: <4C7FFB85.7000006@vlnb.net>	 <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com> <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab0IFVvo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:51:44 -0400
In-Reply-To: <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Chris Weiss <cweiss@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Ross Walker <rswwalker@gmail.com>

Nicholas A. Bellinger, on 09/03/2010 12:12 AM wrote:
>>> I updated the Linux SCSI targets comparison page
>>> http://scst.sourceforge.net/comparison.html, which compares features of
>>> the existing Linux SCSI target subsystems. The comparison includes SCST,
>>> STGT, IET and LIO. I added IET there, because it is the most used Linux
>>> iSCSI target at the moment.
>> .
>> .
>>>
>>> If you see I'm wrong somewhere or forgot something, you are welcome to
>>> correct me and I will fix that.
>>>
>>> Vlad
>>>
>>
>> as a user following the potential inclusion of a kernel-space target,
>> iscsi specifically, I would be very interested in seeing what other
>> pluses the other frameworks have over scst, because if this chart is
>> accurate, all the other targets have quite a ways to go to catch up.
>>
>
> Actually sorry, anyone who has spent more than 30 minutes looking at the
> TCM v4 code that has already been posted to linux-scsi on monday knows
> this list just more handwaving.  I suggest you start doing the same
> (actually discussion specific source file + line refrences) unless you
> actually want to trust this hopelessly out-of-date list on blind
> princaple.

Well, I expected your reaction like that. You have nothing to say, so 
(as usually) prefer to call all "handwaving" and pretend it doesn't exist.

>> To me, lacking correct reserve and task management means "not ready
>> for public consumption".  Making any kernel change that does not have
>> RESERVE/RELEASE and full TM command support is only going to make
>> Linux look buggy and amateur-ish in the storage world.
>
> First, understand that Vlad has been asked to produce a problem use case
> for his CRH=1 (Compatibility Reservation Handling) concerns using the
> SPC-3 RESERVE/RELEASE methods with the TCM v4 code.

For what is CRH here? It has no relation to the problem.

> He has been never
> been able to produce a use case, ever.

I did it at least twice and can do again if somebody ask. I'd suggest 
you to check this list archive. After that STGT and IET teams fixed that 
problem in their implementations.

> Also, just for reference, does
> SCST's SPC-3 persisent reservation handling actually properly support
> CRH=1 emulation from spc4r17..?  Last time I checked, it most certainly
> did *not*.

It does. I'd suggest to check again, starting from scst_reserve_local().

> Second, in terms of TM emulation / passthrough support in the TCM v4
> code, we follow what is implemented in drivers/scsi ML and LLDs,
> primarly to properly for Linux SCSI Initiators.  I honestly don't have
> alot of interesting currently in implementing all of the ancient TM
> emulation that none of the mainline SCSI LLDs in Linux implement today,
> or plan to do the future.  As for specific TM concerns, I am happy to
> address then on a case by case basis with the appropiate use case.

Interesting, from which times ABORT TASK is ancient?

Vlad
