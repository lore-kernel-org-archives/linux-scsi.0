From: Jes Sorensen <jes@wildopensource.com>
Subject: Re: qla1280 endiannes and 64/32bit fixes
Date: 19 Jan 2004 03:54:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yq08yk48gk5.fsf@wildopensource.com>
References: <1074382860.1756.20.camel@mulgrave>
	<20040118024326.GA381527@sgi.com> <1074395819.1756.31.camel@mulgrave>
	<20040118062157.GA11083@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:17592 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S264463AbUASIyE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 03:54:04 -0500
In-Reply-To: <20040118062157.GA11083@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, jeremy@sgi.com

>>>>> "Andrew" == Andrew Vasquez <praka@users.sourceforge.net> writes:

Andrew> Either could I (but then again its late :).  What I did notice
Andrew> was some rather weird code being executed when the CDB calls
Andrew> for no data to transfer (both 64/32_start).  The code in
Andrew> question is this small snippet:

[snip]

Andrew> What exactly are we trying to zero out here?  The IOCB has
Andrew> already been cleared with the following line earlier in the
Andrew> function:

Andrew,

I actually have zero clue why that code was looking like that, it goes
back to the original driver from before I started maintaining
it. Someone in a cube next to you must have written it.

Andrew> Jeremy: have you had any problems with running I/O down the
Andrew> 64bit capable IOCB path?

The 64bit IOCB path has been working great for quite a while, both on
Altix but also as far back as the BigSur boat anchors ;-)

I'll include your change with James' changes into the next release
(modulo the 64 bit addressing bit one as per your explanation).

Cheers,
Jes
