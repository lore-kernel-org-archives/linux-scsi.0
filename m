From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached
 PHYs)
Date: Sat, 22 Oct 2005 19:49:29 +0200
Message-ID: <435A7BA9.4090502@s5r6.in-berlin.de>
References: <4359395B.9030402@pobox.com> <43593FE1.7020506@adaptec.com> <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com> <435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com> <43596070.3090902@pobox.com> <43596859.3020801@adaptec.com> <43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de> <20051022105815.GB3027@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:5614 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750814AbVJVRuD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 13:50:03 -0400
In-Reply-To: <20051022105815.GB3027@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

Christoph Hellwig wrote:
> On Sat, Oct 22, 2005 at 12:42:27PM +0200, Stefan Richter wrote:
>>A. Post mock-ups and pseudo code about how to change the core, discuss.
>>B. Set up a scsi-cleanup tree. In this tree,
>>     1. renovate the core (thereby break all command set drivers and
>>        all transport subsystems),
> 
> No way.  Doing things from scatch is a really bad idea.  See how far we came
> with Linux 2.6 scsi vs 2.4 scsi without throwing everything away and break the
> world.  Please submit changes to fix _one_ thing at a time and fix all users.
> Repeat until done or you don't care anymore.

I agree with you. Alas my wording was misunderstandable und obviously 
carried a wrong tone.

I did not say "replace the core" in step 1. Also, the breakage which I 
refer to in step 1 would have to be immediately corrected in step 2 
(although not for the whole subsystem at once, to allow for a fast cycle 
of validation of what happened in step 1). Furthermore I specifically 
said that most steps may (let me add: and should) overlap.
-- 
Stefan Richter
-=====-=-=-= =-=- =-==-
http://arcgraph.de/sr/
