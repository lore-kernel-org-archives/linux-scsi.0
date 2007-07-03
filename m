From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Some NCQ numbers...
Date: Wed, 04 Jul 2007 00:29:27 +0400
Message-ID: <468AB1A7.9010201@msgid.tls.msk.ru>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <468A06A0.1020802@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> Michael Tokarev wrote:
[]
>> A test drive is Seagate Barracuda ST3250620AS "desktop" drive,
>> 250Gb, cache size is 16Mb, 7200RPM.
[test shows that NCQ makes no difference whatsoever]

> And which elevator?

Well.  It looks like the results does not depend on the
elevator.  Originally I tried with deadline, and just
re-ran the test with noop (hence the long delay with
the answer) - changing linux elevator changes almost
nothing in the results - modulo some random "fluctuations".

In any case, NCQ - at least in this drive - just does
not work.  Linux with its I/O elevator may help to
speed things up a bit, but the disk does nothing in
this area.  NCQ doesn't slow things down either - it
just does not work.

The same's for ST3250620NS "enterprise" drives.

By the way, Seagate announced Barracuda ES 2 series
(in range 500..1200Gb if memory serves) - maybe with
those, NCQ will work better?

Or maybe it's libata which does not implement NCQ
"properly"?  (As I shown before, with almost all
ol'good SCSI drives TCQ helps alot - up to 2x the
difference and more - with multiple I/O threads)

/mjt
