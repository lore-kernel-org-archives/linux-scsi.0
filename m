From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2.6.14-rc1 0/13] ieee1394: fixes and cleanups
Date: Wed, 21 Sep 2005 00:41:20 +0200
Message-ID: <43309010.6010205@s5r6.in-berlin.de>
References: <200509172308.j8HN8ZcH030215@einhorn.in-berlin.de> <20050920213121.GB1114@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:6379 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750704AbVITWln (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 18:41:43 -0400
In-Reply-To: <20050920213121.GB1114@conscoop.ottawa.on.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: Jody McIntyre <scjody@steamballoon.com>, linux-scsi@vger.kernel.org, Ben Collins <bcollins@debian.org>, Dan Dennedy <dan@dennedy.org>, James Bottomley <James.Bottomley@SteelEye.com>

Jody McIntyre wrote:
> Do you have any strong feelings as to what we should do with these
> patches?  My practice has been to send them to akpm for testing in -mm,
> then to Linus after 2 weeks.  All the fixes are for fairly longstanding
> issues AFAICT, so probably not urgent enough to skip that.

What Linus and Andrew do with these patches is ultimately up to them. In 
my opinion they could/should go straight into Linus' tree because they 
are ...well... fixes and cleanups. There are no new features, no risky 
rewrites.

Furthermore, there _is_ a certain urgency IMO. Linux1394.org's stuff and 
Linus' tree are already diverging again. So I became a little bit 
worried, which is one of the reasons why I put these patches together.

Also note that one group of patches is missing from this collection, as 
I already mentioned. I left sbp2's RBC related changes out. (I promise 
to produce a patch against the then latest -rc or -rc-mm with these 
changes as soon as I have the time; probably at the beginning of 
October. Of course I won't mind if somebody else did it...) _This_ kind 
of changes belongs into -mm first. (Actually it was already there; made 
it even into Linus' tree, but luckily was reverted.)

This is actually another reason why the other patches should better go 
into Linus' tree already. We have to have released kernels with an sbp2 
driver that actually works. Only a working, released kernel as basis of 
reference makes it possible to actually test changes like the RBC 
related ones.

Also note: Incarnations of the sbp2 hot-unplug patch, the whole 
serialize_io matter, and patch 5/13 (reordering to nodemgr's IRM duties) 
have actually received testing by kind readers of linux1394-devel and 
linux1394-user. This is certainly a different circle of testers than 
those who are running -mm kernels. However it's a very valid way of 
testing because there were _fixes_ to test, not new features or code 
rearrangements.

(That was a long answer... However, don't take me wrong. I don't want to 
push anything and I don't have strong feelings what should happen with 
the patches.)

> In any case,
> they should be sent in by Ben or myself, to avoid confusing people :)

Well, _somebody_ should do it. :-)
And I agree that confusion should be avoided. No need to add more 
friction to the process.
-- 
Stefan Richter
-=====-=-=-= =--= =-=--
http://arcgraph.de/sr/
