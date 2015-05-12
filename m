From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
Date: Tue, 12 May 2015 16:04:04 +0200
Message-ID: <87iobx7uzv.fsf@rasmusvillemoes.dk>
References: <1423233221-27069-1-git-send-email-linux@rasmusvillemoes.dk>
	<bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:36225 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbbELOEH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 10:04:07 -0400
Received: by lbbqq2 with SMTP id qq2so6668274lbb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 07:04:05 -0700 (PDT)
In-Reply-To: <bb45ec6cfa94612741a2eb355d0de566@mail.gmail.com> (Kashyap
	Desai's message of "Tue, 10 Feb 2015 22:16:05 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>

On Tue, Feb 10 2015, Kashyap Desai <kashyap.desai@avagotech.com> wrote:

> Acked-by: Kashyap Desai <kashyap.desai@avagotech.com>
>
>> -----Original Message-----
>> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
>> Sent: Friday, February 06, 2015 8:04 PM
>> To: Kashyap Desai; Sumit Saxena; Uday Lingala; James E.J. Bottomley
>> Cc: Rasmus Villemoes; megaraidlinux.pdl@avagotech.com; linux-
>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH] scsi: megaraid_sas: Prevent future %p disaster
>>
>> There is currently no %po format extension, so currently the letters
> "on" are
>> simply skipped and the pointer is printed as expected (while missing the
> word
>> on). However, it is probably only a matter of time before someone comes
> up
>> with a %po extension, at which point this is likely to fail
> spectacularly.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Any chance either this minimal fix or Joe's more thorough cleanup could
get applied? There's still no %po extension, but there's certainly a lot
of proposals for more %p extensions flying around LKML, so I still think
the "only a matter of time" holds.

Rasmus
