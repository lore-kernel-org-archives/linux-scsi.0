From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sg regression in 2.6.16-rc5
Date: Fri, 03 Mar 2006 11:43:45 -0500
Message-ID: <44087241.3090702@torque.net>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net> <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org> <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local> <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org> <20060302230814.GB16237@merlin.emma.line.org> <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:38534 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S932320AbWCCQo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Mar 2006 11:44:56 -0500
In-Reply-To: <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Matthias Andree <matthias.andree@gmx.de>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 3 Mar 2006, Matthias Andree wrote:
> 
>>Please make up your mind if you want regressions reported and removed
>>before release or if you want 2.6.16 to be an experimental release.
> 
> 
> The _one_ regression that was reported already has a fix.
> 
> As far as I can tell, the rest of the thread has been _whining_.

Well thanks for the characterization as a whiner. I may
not follow the party line but I try not to resort to
name calling. Do you want dissenters around or do you
think that it is fine to impose block subsystem rules
on non block drivers? Yes, I have been told the block
subsystem is generic, if so why does it enforce concepts
like max_sectors ?

> Guys, what's so hard with just raising the limits on the common SG_IO 
> thing (the same way people had to raise the limits on the _old_ sg-only 
> thing), instead of whining about it?

... and I believe that is the correct solution and what,
I believe, Mike Christie who is the author of "st/sg
scatter gather list merge" change wants to do. But
since the requirement has just come up, it is unlikely
that code code be produced it time for lk 2.6.16 .
