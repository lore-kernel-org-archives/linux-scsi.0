From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: sg regression in 2.6.16-rc5
Date: Thu, 2 Mar 2006 15:20:26 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0603021518430.22647@g5.osdl.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net>
 <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org>
 <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local>
 <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
 <20060302230814.GB16237@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:20678 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751387AbWCBXUt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 18:20:49 -0500
In-Reply-To: <20060302230814.GB16237@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Douglas Gilbert <dougg@torque.net>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org



On Fri, 3 Mar 2006, Matthias Andree wrote:
> 
> Please make up your mind if you want regressions reported and removed
> before release or if you want 2.6.16 to be an experimental release.

The _one_ regression that was reported already has a fix.

As far as I can tell, the rest of the thread has been _whining_.

Guys, what's so hard with just raising the limits on the common SG_IO 
thing (the same way people had to raise the limits on the _old_ sg-only 
thing), instead of whining about it?

		Linus
