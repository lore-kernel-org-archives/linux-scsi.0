From: Humberto Massa <humberto.massa@almg.gov.br>
Subject: Re: Binary-only firmware covered by the GPL?
Date: Tue, 30 Mar 2004 11:57:40 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40698AE4.7020006@almg.gov.br>
References: <8RnZwD.A.91B.qHYaAB@murphy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hades.almg.gov.br ([200.198.60.36]:33464 "EHLO
	hades.almg.gov.br") by vger.kernel.org with ESMTP id S263694AbUC3O4o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2004 09:56:44 -0500
In-Reply-To: <8RnZwD.A.91B.qHYaAB@murphy>
List-Id: linux-scsi@vger.kernel.org
To: debian-devel@lists.debian.org
Cc: debian-legal@lists.debian.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Oh, man, it seems that I *must* repeat myself one more time, at least
to see if I'm not in everyone's killfile :-)

@ 30/03/2004 11:19 : wrote Pavel Machek :

> Hi!
Hi!
> 
> 
>>> #include <hallo.h> * David Schwartz [Thu, Mar 25 2004,
>>> 04:41:23PM]:
>>>>> IMHO code that can be compiled would probably be the
>>>>> preferred form of the work.
>>>> You are seriously arguing that the obfuscated binary of the 
>>>> firmware is the preferred form of the firmware for the
>>>> purpose of making modifications to it?!
I don't know if that's what /he/ is arguing, but *I* am arguing that 
in the cases I've seen here and in debian-legal, we have the following 
circumstances (the qla2xxx/ql2100_fw.c canonical example):
* the file in question (and its brothers and cousins) have the 
following structure IIRC:
	+ GPL license comment-header
	+ some includes?
	+ the firmware in c-blob format or unsigned char fw[] = ....
	+ nothing else.
* as the file is clearly marked by the copyright holder as being 
_distributed under the terms of the GPL_ and no other format is given 
to modify the fw[], at least *legally* is MHO that any 
recipient/redistributor of the file _can_ and _must_ consider the file 
in *that* format as the preferred form for modification (pf4m) *and*, 
considering it the source code, follow the directions of the GPL in 
respect to modification and redistribution.
* the /status quo/ obtained by observation of the previous item 
prevails _until somebody proves_ that the fw[] = {} is *not* the 
source code; this, usually, can be proven only by confession, i.e., 
the original copyright holder *comes out and says:* "hmmm, this is not 
the source code". Notice that the copyright holder maintaining silence 
is _not_ confession.
* in this case (copyright holder confesses it's not the source code) 
applied to the examples in casu, i.e., firmware, the kernel people 
cannot distribute the binary blob *inside the kernel tree*, but can do 
it separately _if the copyright holder grants a license_ to.
* even so, Debian could not distribute it.

>>> Yes, the driver authors PREFERS to make the changes on the C
>>> source code, he never has to modify the firmware. Exactly what
>>> the GPL requests, where is your problem?
>> 
>> But the firmware didn't appear out of thin air - someone wrote it
>>  somehow. If that's using a hex editor or inside the C code
>> doesn't matter, but most likely they used some other language
>> like either C or assembly (no, not all firmware is written using
>> assembly), and there are cases where some are in fact written
>> using a hex editor but I can't remember any that has been for the
>> last 30 or so years but I'm sure there has been cases where there
>> hasn't been a working assembler.

But there are cases, even if you don't know of them. And this is the 
case that has to be taken in account when we start *presuming* things, 
at least legally, IMHO.
> If my code contains picture of human, do I have to provide his DNA,
> too? Pavel
> 
> (runs away)


-- 
best regards,M
