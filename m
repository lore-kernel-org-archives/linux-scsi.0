From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [eSATA] 2.6.28.7: IO errors
Date: Sat, 28 Mar 2009 11:38:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0903280139340.4635@axis700.grange>
References: <Pine.LNX.4.64.0903280001020.4635@axis700.grange> <20090327235817.GP8014@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50376 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753323AbZC1Ki1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Mar 2009 06:38:27 -0400
In-Reply-To: <20090327235817.GP8014@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Tejun Heo <tj@kernel.org>

Hi Matthew,

On Fri, 27 Mar 2009, Matthew Wilcox wrote:

> On Sat, Mar 28, 2009 at 12:18:38AM +0100, Guennadi Liakhovetski wrote:
> > I'm using an external eSATA / USB / Firewire 2x1T RAID from WD in RAID1 
> 
> Looks like your problems are solved by
> 9062712fa9ed13b531dfc2228086650b8bd6a255

(added Tejun as the patch author and owner of similar hardware)

AFAIU, that patch improves or fixes error handling on those drives, and 
the symptom, that Tejun was observing, was that the drive was hanging and 
required a power cycle.

In my case the drive didn't need a power cycle, and error handling did 
work, AFAICS, but even just having that error seems not healthy for the 
data, which is confirmed by ext4 errors. Am I right? (BTW, I was 
impressed, that after replugging the drive to firewire and running fsck on 
a 800G big ext4 partition, it only needed around a second or two to replay 
the journal and then it was ok! I hope the fileystem also has indeed been 
repaired...)

Error handling is great, but I think what I want is to avoid such errors 
altogether. So, my question was - can those errors be indeed caused by the 
unstable eSATA connector in the drive? Tejun, you have similar drives, do 
yours also have such a problem? How are you solving it? Is the only way to 
improve the connector stability by milling the plastic casing to actually 
be able to insert the connector properly or by contacting the retailer for 
a replacement?... Sorry, these are not directly Linux driver questions, 
but the questions are really what those error messages tell me about the 
possible reasons for the problem:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
