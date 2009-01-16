From: Grant Grundler <grundler@google.com>
Subject: Re: [GIT PATCH] firs round of SCSI bug fixes for 2.6.29-rc1
Date: Fri, 16 Jan 2009 11:02:12 -0800
Message-ID: <da824cf30901161102r67b9c31euc12fc95fb8330a07@mail.gmail.com>
References: <1232117771.3224.21.camel@localhost.localdomain>
	 <20090116090928.e43c986e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:50157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbZAPTCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jan 2009 14:02:18 -0500
In-Reply-To: <20090116090928.e43c986e.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Jan 16, 2009 at 9:09 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
...
>> +             CHIPREG_WRITE32(&ioc->chip->Doorbell, 0xC0FFEE00);
>> +             panic("%s: Firmware is halted due to command timeout\n",
>> +                     ioc->name);
>> +     }
>> +}
>> +EXPORT_SYMBOL(mpt_halt_firmware);
>
> Doing a panic() after we've already detected an error is plain nasty.
> Is there no way in which we can allow the kernel to continue?

Basically what James said. It's not long though: only 6 emails.
I started that thread thinking the same thing you did:
    http://marc.info/?t=123123569200003&r=1&w=2

TBH, I still wouldn't implement it the way LSI maintainers did.
I'm happy they are the maintainers and it's their call.

grant
