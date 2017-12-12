From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] SCSI fixes for 4.15-rc3
Date: Tue, 12 Dec 2017 12:22:44 -0500
Message-ID: <yq1indbq2sb.fsf@oracle.com>
References: <1513095686.3110.9.camel@HansenPartnership.com>
        <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:52254 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdLLR1z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2017 12:27:55 -0500
In-Reply-To: <CA+55aFy8hepLBW9Zvfk4MgibG4eHF5qkmon+2Zs6KWLQfFH-fg@mail.gmail.com>
        (Linus Torvalds's message of "Tue, 12 Dec 2017 09:16:16 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


Linus,

> This is utter shite, and doesn't even compile cleanly.
>
> Sure, it's "just" a warning, and the code works. But no, I'm not
> pulling crap like this. If you save a pointer in an integer
> "hostdata[0]" field, then you damn well do the proper casts or helper
> functions or something, you don't just ignore the compiler when it
> very reasonably warns about it.
>
> What the hell is going on? Nobody compiled this stuff at all? Or
> nobody cares about new build warnings?

Arnd and Johannes fixed this up right away:

https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git/commit/?h=fixes&id=45349821ab3a8d378b8f37e52c6fe1aa1b870c47

-- 
Martin K. Petersen	Oracle Linux Engineering
