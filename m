From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Some NCQ numbers...
Date: Wed, 4 Jul 2007 06:22:48 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0707040621170.32656@p34.internal.lan>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com>
 <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com>
 <468B6BD7.9010108@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <468B6BD7.9010108@msgid.tls.msk.ru>
Sender: linux-ide-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Tejun Heo <htejun@gmail.com>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Jul 2007, Michael Tokarev wrote:

> Tejun Heo wrote:
>> Hello,
>>
>> Michael Tokarev wrote:
>>> Well.  It looks like the results does not depend on the
>>> elevator.  Originally I tried with deadline, and just
>>> re-ran the test with noop (hence the long delay with
>>> the answer) - changing linux elevator changes almost
>>> nothing in the results - modulo some random "fluctuations".
>>
>> I see.  Thanks for testing.
>
> Here are actual results - the tests were still running when
> I replied yesterday.
>
> Again, this is Seagate ST3250620AS "desktop" drive, 7200RPM,
> 16Mb cache, 250Gb capacity.  The tests were performed with
> queue depth = 64 (on mptsas), drive write cache is turned
> off.

I found AS scheduler to be the premium and best for single-user performance.

You want speed? Use AS.

http://home.comcast.net/~jpiszcz/sched/cfq_vs_as_vs_deadline_vs_noop.html

