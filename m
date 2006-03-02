From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sg regression in 2.6.16-rc5
Date: Fri, 3 Mar 2006 00:08:14 +0100
Message-ID: <20060302230814.GB16237@merlin.emma.line.org>
References: <E94491DE-8378-41DC-9C01-E8C1C91B6B4E@mac.com> <4404AA2A.5010703@torque.net> <20060301083824.GA9871@merlin.emma.line.org> <Pine.LNX.4.64.0603011027400.22647@g5.osdl.org> <4405F6F1.9040106@torque.net> <Pine.LNX.4.63.0603012239440.5789@kai.makisara.local> <44074CA1.3000007@torque.net> <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:45795 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751076AbWCBXIU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 18:08:20 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0603021317520.22647@g5.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Douglas Gilbert <dougg@torque.net>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Matthias Andree <matthias.andree@gmx.de>, Mark Rustad <mrustad@mac.com>, linux-scsi@vger.kernel.org

On Thu, 02 Mar 2006, Linus Torvalds wrote:

> Considering that the old code was apparently known-broken due to not 
> honoring the use_clustering flag, I would say that the more likely thing 
> is that very few people use sg in the first place, and we should wait and 
> see what the reaction is to actually fixing a real bug.

Please make up your mind if you want regressions reported and removed
before release or if you want 2.6.16 to be an experimental release. This
back and forth isn't going to make Linux any more trustworthy.

-- 
Matthias Andree
