From: PinkFreud <pf-linux-scsi-20040717@mirkwood.net>
Subject: Re: sym53c8xx_2 funkiness...
Date: Tue, 10 Aug 2004 00:10:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040810041038.GC5835@eriador.mirkwood.net>
References: <20040718030514.GJ1105@eriador.mirkwood.net> <20040724165625.GA1105@eriador.mirkwood.net> <m3zn5nxi6j.fsf@merlin.emma.line.org> <20040726160214.GB1105@eriador.mirkwood.net> <20040726161825.GA14799@merlin.emma.line.org> <20040728124509.GK1105@eriador.mirkwood.net> <20040809223625.GA8782@logos.cnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pcp09898885pcs.ewndsr01.nj.comcast.net ([68.39.7.159]:1284 "HELO
	rivendell.mirkwood.net") by vger.kernel.org with SMTP
	id S267416AbUHJEKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2004 00:10:40 -0400
Content-Disposition: inline
In-Reply-To: <20040809223625.GA8782@logos.cnet>
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Cc: linux-scsi@vger.kernel.org

I tried Matthias' suggestion of disabling disconnect - didn't seem to
do much to alleviate the problem.

In the end, I just switched my network gateway functions to another
box.  Other than a failing IDE disk (damn, I'm having all sorts of fun
here...), it's behaving (the scsi disk taken from the other box works,
too).

I noted that 2.6.x seems to exhibit the same problem.  However, I don't
really have the time or inclination to play with this right now - I
need something working here at home.  :)

That being said, it *would* be nice to see that driver working again.
As I stated, though, I tried emailing Gerard Roudier, only to have my
email bounce (mailbox full).

*sigh*

Thanks, Marcelo and Matthias.  It was worth a try.


On Mon, Aug 09, 2004 at 07:36:25PM -0300, Marcelo Tosatti babbled thus:
> 
> You can try to get 2.4.19's driver working on 2.4.26.
> 
> 2.6.x also exhibits the same problem

-- 
                                                                      
Mike Edwards                    |   If this email address disappears,   
Unsolicited advertisments to    |   assume it was spammed to death.  To
this address are not welcome.   |   reach me in that case, s/-.*@/@/
(This means you, Cogent!)       |                                   
