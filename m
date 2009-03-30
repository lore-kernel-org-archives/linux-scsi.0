From: Tejun Heo <tj@kernel.org>
Subject: Re: [eSATA] 2.6.28.7: IO errors
Date: Mon, 30 Mar 2009 17:25:10 +0900
Message-ID: <49D081E6.5010609@kernel.org>
References: <Pine.LNX.4.64.0903280001020.4635@axis700.grange> <20090327235817.GP8014@parisc-linux.org> <Pine.LNX.4.64.0903280139340.4635@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:37401 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZC3IZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Mar 2009 04:25:19 -0400
In-Reply-To: <Pine.LNX.4.64.0903280139340.4635@axis700.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Hello,

Guennadi Liakhovetski wrote:
> Hi Matthew,
> 
> On Fri, 27 Mar 2009, Matthew Wilcox wrote:
> 
>> On Sat, Mar 28, 2009 at 12:18:38AM +0100, Guennadi Liakhovetski wrote:
>>> I'm using an external eSATA / USB / Firewire 2x1T RAID from WD in RAID1 
>> Looks like your problems are solved by
>> 9062712fa9ed13b531dfc2228086650b8bd6a255
> 
> (added Tejun as the patch author and owner of similar hardware)

Thanks for forwarding.

> AFAIU, that patch improves or fixes error handling on those drives, and 
> the symptom, that Tejun was observing, was that the drive was hanging and 
> required a power cycle.
> 
> In my case the drive didn't need a power cycle, and error handling did 
> work, AFAICS, but even just having that error seems not healthy for the 
> data, which is confirmed by ext4 errors. Am I right?

No, your drive checked out after the last error even after the link
speed had been lowered to 1.5Gbps, so the EH did everything it could
but no candy.  The drive still checked out.

> Error handling is great, but I think what I want is to avoid such errors 
> altogether. So, my question was - can those errors be indeed caused by the 
> unstable eSATA connector in the drive? Tejun, you have similar drives, do 
> yours also have such a problem? How are you solving it?

I don't use the drives extensively but shorter cables seem to solve a
lot of the issues during testing.  Or rather, longer cables triggered
a LOT of problems.

> Is the only way to improve the connector stability by milling the
> plastic casing to actually be able to insert the connector properly
> or by contacting the retailer for a replacement?... Sorry, these are
> not directly Linux driver questions, but the questions are really
> what those error messages tell me about the possible reasons for the
> problem:-)

Give a shot at shorter cable.

Good luck!

-- 
tejun
