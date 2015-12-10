From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH] [SCSI] osd: fix signed char versus %02x issue
Date: Thu, 10 Dec 2015 21:10:17 +0200
Message-ID: <CAHp75Vcze4m8OeY=0wuiUtE_LgoifmmhdRKM2sQTAT-_Y3DFjg@mail.gmail.com>
References: <1449584716-21093-1-git-send-email-linux@rasmusvillemoes.dk>
	<yq1zixi186s.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:34446 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbLJTKS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2015 14:10:18 -0500
In-Reply-To: <yq1zixi186s.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Boaz Harrosh <ooo@electrozaur.com>, Benny Halevy <bhalevy@primarydata.com>, "James E.J. Bottomley" <JBottomley@odin.com>, osd-dev@open-osd.org, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Dec 10, 2015 at 8:15 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Rasmus" == Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
>
> Rasmus> If char is signed and one of these bytes happen to have a value
> Rasmus> outside the ascii range, the corresponding output will consist
> Rasmus> of "ffffff" followed by the two hex chars that were actually
> Rasmus> intended. One way to fix it would be to change the casts to
> Rasmus> (u8*) aka (unsigned char*), but it is much simpler (and
> Rasmus> generates smaller code) to use the %ph extension which was
> Rasmus> created for such short hexdumps.
>
> Applied to 4.5/scsi-queue.

How fast!

Martin, I have several patches on SCSI subsytem like this one. Some of
them didn't manage kernel (even having Ack!) for years already.
Is it okay if I collect them together and send a bunch once again Cc'ing you?

-- 
With Best Regards,
Andy Shevchenko
