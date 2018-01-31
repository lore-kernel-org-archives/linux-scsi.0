From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 4.14+ merge
 window
Date: Wed, 31 Jan 2018 12:16:36 -0800
Message-ID: <1517429796.3344.10.camel@HansenPartnership.com>
References: <1517420549.3937.67.camel@HansenPartnership.com>
         <CA+55aFy4YfNEKiDipUXM_KYR5wen-8hmOp7B7t+=boq14EgdJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60530 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752171AbeAaUQh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Jan 2018 15:16:37 -0500
In-Reply-To: <CA+55aFy4YfNEKiDipUXM_KYR5wen-8hmOp7B7t+=boq14EgdJA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2018-01-31 at 11:29 -0800, Linus Torvalds wrote:
> On Wed, Jan 31, 2018 at 9:42 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-
> > misc
> 
> Ok, now I did indeed get that
> 
>   gpg: Can't check signature: unknown pubkey algorithm
> 
> because of your fancy new key. But making git use gpg2 indeed fixes
> it, since I have a recent enough version.
> 
> Let's see if anybody else even notices. I don't think lots of people
> look at the signatures.

Great! thanks for being the guinea pig.  At least we know the theory is
now tested.

Regards,

James
