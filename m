From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 08 Feb 2008 13:37:28 +0300
Message-ID: <47AC30E8.6010205@vlnb.net>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>  <1202144767.3096.38.camel@localhost.localdomain>  <47A7488B.4080000@vlnb.net>  <1202145901.3096.49.camel@localhost.localdomain>  <47A751C5.60600@vlnb.net>  <1202149322.3096.66.camel@localhost.localdomain>  <47A75B8A.3020503@vlnb.net>  <1202151293.3096.80.camel@localhost.localdomain>  <47A8B210.8040202@vlnb.net>  <1202238802.3133.71.camel@localhost.localdomain> <e2e108260802070513t4eeb9a9fucfe9821d94bd7f82@mail.gmail.com> <47AB0B63.20500@vlnb.net> <alpine.DEB.1.00.0802071437404.12791@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:48763 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932945AbYBHKh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 05:37:29 -0500
In-Reply-To: <alpine.DEB.1.00.0802071437404.12791@asgard.lang.hm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: david@lang.hm
Cc: Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

david@lang.hm wrote:
> On Thu, 7 Feb 2008, Vladislav Bolkhovitin wrote:
> 
>> Bart Van Assche wrote:
>>
>>> - It has been discussed which iSCSI target implementation should be in
>>> the mainstream Linux kernel. There is no agreement on this subject
>>> yet. The short-term options are as follows:
>>> 1) Do not integrate any new iSCSI target implementation in the
>>> mainstream Linux kernel.
>>> 2) Add one of the existing in-kernel iSCSI target implementations to
>>> the kernel, e.g. SCST or PyX/LIO.
>>> 3) Create a new in-kernel iSCSI target implementation that combines
>>> the advantages of the existing iSCSI kernel target implementations
>>> (iETD, STGT, SCST and PyX/LIO).
>>>
>>> As an iSCSI user, I prefer option (3). The big question is whether the
>>> various storage target authors agree with this ?
>>
>>
>> I tend to agree with some important notes:
>>
>> 1. IET should be excluded from this list, iSCSI-SCST is IET updated 
>> for SCST framework with a lot of bugfixes and improvements.
>>
>> 2. I think, everybody will agree that Linux iSCSI target should work 
>> over some standard SCSI target framework. Hence the choice gets 
>> narrower: SCST vs STGT. I don't think there's a way for a dedicated 
>> iSCSI target (i.e. PyX/LIO) in the mainline, because of a lot of code 
>> duplication. Nicholas could decide to move to either existing 
>> framework (although, frankly, I don't think there's a possibility for 
>> in-kernel iSCSI target and user space SCSI target framework) and if he 
>> decide to go with SCST, I'll be glad to offer my help and support and 
>> wouldn't care if LIO-SCST eventually replaced iSCSI-SCST. The better 
>> one should win.
> 
> 
> why should linux as an iSCSI target be limited to passthrough to a SCSI 
> device.
> 
> the most common use of this sort of thing that I would see is to load up 
> a bunch of 1TB SATA drives in a commodity PC, run software RAID, and 
> then export the resulting volume to other servers via iSCSI. not a 
> 'real' SCSI device in sight.
> 
> As far as how good a standard iSCSI is, at this point I don't think it 
> really matters. There are too many devices and manufacturers out there 
> that implement iSCSI as their storage protocol (from both sides, 
> offering storage to other systems, and using external storage). 
> Sometimes the best technology doesn't win, but Linux should be 
> interoperable with as much as possible and be ready to support the 
> winners and the loosers in technology options, for as long as anyone 
> chooses to use the old equipment (after all, we support things like 
> Arcnet networking, which lost to Ethernet many years ago)

David, your question surprises me a lot. From where have you decided 
that SCST supports only pass-through backstorage? Does the RAM disk, 
which Bart has been using for performance tests, look like a SCSI device?

SCST supports all backstorage types you can imagine and Linux kernel 
supports.

> David Lang
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

