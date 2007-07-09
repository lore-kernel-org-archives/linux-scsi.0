From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Some NCQ numbers...
Date: Mon, 9 Jul 2007 14:26:31 +0200
Message-ID: <20070709122631.GR5267@kernel.dk>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com> <468B6BD7.9010108@msgid.tls.msk.ru> <Pine.LNX.4.64.0707040621170.32656@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18702 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbXGIM0X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2007 08:26:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707040621170.32656@p34.internal.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Tejun Heo <htejun@gmail.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 04 2007, Justin Piszcz wrote:
>  On Wed, 4 Jul 2007, Michael Tokarev wrote:
> 
> > Tejun Heo wrote:
> >> Hello,
> >>
> >> Michael Tokarev wrote:
> >>> Well.  It looks like the results does not depend on the
> >>> elevator.  Originally I tried with deadline, and just
> >>> re-ran the test with noop (hence the long delay with
> >>> the answer) - changing linux elevator changes almost
> >>> nothing in the results - modulo some random "fluctuations".
> >>
> >> I see.  Thanks for testing.
> >
> > Here are actual results - the tests were still running when
> > I replied yesterday.
> >
> > Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
> > 16Mb cache, 250Gb capacity.  The tests were performed with
> > queue depth = 64 (on mptsas), drive write cache is turned
> > off.
> 
>  I found AS scheduler to be the premium and best for single-user performance.
> 
>  You want speed? Use AS.
> 
>  http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline_vs_noop.html

Hmm, I find your data very weak for such a conclusion. Value of the test
itself withstanding, AS seems to be a lot faster for sequential output
for some reason, yet slower for everything else. Which is odd, deadline
should always be running at the same speed for writeout as AS. The only
real difference should be sequential and random reads.

So allow me to call your results questionable. It also looks like bonnie
(some version) output, I never found bonnie to provide good and
repeatable numbers. tiotest is much better, or (of course) fio.

-- 
Jens Axboe

