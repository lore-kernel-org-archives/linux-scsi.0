From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Fri, 21 Oct 2005 15:39:58 -0400
Message-ID: <4359440E.2050702@pobox.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>	 <20051020160155.GA14296@lst.de> <4357CB03.4020400@adaptec.com>	 <20051020170330.GA16458@lst.de>  <4357F7DE.7050004@adaptec.com> <1129852879.30258.137.camel@bluto.andrew> <43583A53.2090904@pobox.com> <435929FD.4070304@adaptec.com> <43593100.5040708@pobox.com> <43593884.7000800@adaptec.com> <4359395B.9030402@pobox.com> <43593FE1.7020506@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965126AbVJUTkK@vger.kernel.org>
In-Reply-To: <43593FE1.7020506@adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> On 10/21/05 14:54, Jeff Garzik wrote:
> 
>>I'm trying to tell it like it is, in the hopes that you will eventually 
>>learn the process, and be a good upstream maintainer we can all work with.
> 
> 
> Look how you're using "all", generalizing left and right.  You just want to
> create this FUD and spread this FUD that I don't work well with anyone.  Yep,
> this is a pretty low blow.  While in fact did you talk to everyone I work with?
> 
> I say, when people are losing it on the technical front, they try to attack
> personally and on political basis.


The technical stuff got covered long ago.  Here are the basic basics:

* aic94xx needs to have the scsi-host-template in the LLDD, to fix 
improper layering.
* SAS generic code needs to use SAS transport class, which calls 
scsi_scan_target(), to avoid code duplication.
* other stuff I listed in my "analysis" email, including updating libata 
to support SAS+SATA hardware.

This is the stuff that I have been working on (nothing pushed to sas-2.6 
yet, as it doesn't yet boot locally).

If you were willing to do this stuff, _working with others_, then I 
would be off in happy happy SATA land right now, and you would have been 
nominated to be the Linux SAS maintainer.

Call it FUD, politics, personal attacks, wanking off to please 
manglement, whatever.  My goal has always been to (a) help Linux users 
by getting aic94xx+SAS upstream, and (b) try to help you understand why 
your code didn't go upstream verbatim, long after others have given up 
trying to do that.

	Jeff, he of infinite patience
