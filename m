From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: sym53c8xx_2 funkiness...
Date: Tue, 10 Aug 2004 09:19:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810071953.GA10247@merlin.emma.line.org>
References: <20040718030514.GJ1105@eriador.mirkwood.net> <20040724165625.GA1105@eriador.mirkwood.net> <m3zn5nxi6j.fsf@merlin.emma.line.org> <20040726160214.GB1105@eriador.mirkwood.net> <20040726161825.GA14799@merlin.emma.line.org> <20040728124509.GK1105@eriador.mirkwood.net> <20040809223625.GA8782@logos.cnet> <20040810041038.GC5835@eriador.mirkwood.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:43409 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S267466AbUHJHT4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 03:19:56 -0400
Content-Disposition: inline
In-Reply-To: <20040810041038.GC5835@eriador.mirkwood.net>
List-Id: linux-scsi@vger.kernel.org
To: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, linux-scsi@vger.kernel.org

On Tue, 10 Aug 2004, PinkFreud wrote:

> I tried Matthias' suggestion of disabling disconnect - didn't seem to
> do much to alleviate the problem.
> 
> In the end, I just switched my network gateway functions to another
> box.  Other than a failing IDE disk (damn, I'm having all sorts of fun
> here...), it's behaving (the scsi disk taken from the other box works,
> too).
> 
> I noted that 2.6.x seems to exhibit the same problem.  However, I don't
> really have the time or inclination to play with this right now - I
> need something working here at home.  :)
> 
> That being said, it *would* be nice to see that driver working again.
> As I stated, though, I tried emailing Gerard Roudier, only to have my
> email bounce (mailbox full).

The 2.6 driver is maintained by Matthew Wilcox; try mailing the
linux-scsi list again.

-- 
Matthias Andree

NOTE YOU WILL NOT RECEIVE MY MAIL IF YOU'RE USING SPF!
Encrypted mail welcome: my GnuPG key ID is 0x052E7D95 (PGP/MIME preferred)
