From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: Spamming linux-kernel and linux-scsi by out-of-tree patches	(LIO)
Date: Mon, 26 Jan 2009 19:08:24 +0300
Message-ID: <497DDFF8.8070707@vlnb.net>
References: <497DB7D0.8000302@vlnb.net> <1232984234.3248.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbZAZQIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2009 11:08:22 -0500
In-Reply-To: <1232984234.3248.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


James Bottomley, on 01/26/2009 06:37 PM wrote:
> On Mon, 2009-01-26 at 16:17 +0300, Vladislav Bolkhovitin wrote:
>> Nicholas,
>>
>> Could you stop spamming linux-kernel and linux-scsi mailing lists by 
>> patches for your out-of-tree LIO project, please?
>>
>> Those mailing lists are intended for patches for in-kernel components 
>> only, not for all out-of-tree projects, finding their ways into the 
>> mainline. I don't see any reason why your project should be an 
>> exception. Think, what a mess the kernel mailing lists would get, if all 
>> out-of-tree projects started sending their patches to them?
> 
> Actually, out of tree projects trying to make their way upstream are
> welcome to use the various linux- mailing lists to solicit feedback and
> review.  This method was, for instance, how FCoE made it in.

Hmm, I might be wrong, but what I've seen that FCoE only at the 
beginning used linux-scsi for its intermediate patches, then such 
patches quickly went into FCoE internal development mailing list only. 
Then only resulting patches intended for wide review and mainline 
inclusion were sent to linux-scsi. This is how I thought it's usually 
considered should be done and how all the projects I've seen so far did.

I wouldn't object if Nicholas does the same and send in linux-scsi and 
linux-kernel a complete patchset, which we will review and discuss. But 
he sends *intermediate* patches and this looks for me like a violation 
of fundamental rules/intention of Linux kernel mailing lists, hence I 
complain.

So, should I understand your words that you agree if I also start 
sending intermediate patches for SCST to linux-scsi/linux-kernel?

>> My personal practical concerns about your patches that they trigger my 
>> e-mail filters, so I have to spend on them much more time than I would want.
> 
> I've found that spamassassin does a good job of marking patches as non
> spam.  Also, if you're using zmailer, vger seems to have some type of
> patch recognition system built in which might be worth co-opting.

Thanks for the suggestions, but, unfortunately, none of those filters 
can distinguish e-mails/patches sent by Nicholas Bellinger in some 
important SCSI target related discussion from his unsolicited 
intermediate patches, which I should ignore.

Vlad
