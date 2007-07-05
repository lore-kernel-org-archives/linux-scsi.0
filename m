From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Some NCQ numbers...
Date: Thu, 05 Jul 2007 15:22:29 -0400
Message-ID: <468D44F5.4070906@tmr.com>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com> <468B6BD7.9010108@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:34742 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbXGILSu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2007 07:18:50 -0400
In-Reply-To: <468B6BD7.9010108@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Tejun Heo <htejun@gmail.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Michael Tokarev wrote:
> Tejun Heo wrote:
>> Hello,
>>
>> Michael Tokarev wrote:
>>> Well.  It looks like the results does not depend on the
>>> elevator.  Originally I tried with deadline, and just
>>> re-ran the test with noop (hence the long delay with
>>> the answer) - changing linux elevator changes almost
>>> nothing in the results - modulo some random "fluctuations".
>> I see.  Thanks for testing.
> 
> Here are actual results - the tests were still running when
> I replied yesterday.
> 
> Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
> 16Mb cache, 250Gb capacity.  The tests were performed with
> queue depth = 64 (on mptsas), drive write cache is turned
> off.
> 
But... with write cache off you don't let the drive do some things which 
might show a lot of improvement with one scheduler or another. So your 
data are only part of the story, aren't they?

[snip]

>>> By the way, Seagate announced Barracuda ES 2 series
>>> (in range 500..1200Gb if memory serves) - maybe with
>>> those, NCQ will work better?
>> No one would know without testing.
> 
> Sure thing.  I guess I'll set up a web page with all
> the results so far, in a hope someday it will be more
> complete (we don't have many different drives to test,
> but others do).
> 
> By the way.  Both SATA drives we have are single-platter
> ones (with 500Gb models they've 2 platters, and 750Gb
> ones are with 3 platters), while all SCSI drives I
> tested have more than one platters.  Maybe this is
> yet another reason for NCQ failing.
> 
> And another note.  I heard somewhere that Seagate for
> one prohibits publishing of tests like this, however
> I haven't signed any NDAs and somesuch when purchased
> their drives in a nearest computer store... ;)
> 
>>> Or maybe it's libata which does not implement NCQ
>>> "properly"?  (As I shown before, with almost all
>>> ol'good SCSI drives TCQ helps alot - up to 2x the
>>> difference and more - with multiple I/O threads)
>> Well, what the driver does is minimal.  It just passes through all the
>> commands to the harddrive.  After all, NCQ/TCQ gives the harddrive more
>> responsibility regarding request scheduling.
> 
> Oh well, I see.... :(
> 

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
