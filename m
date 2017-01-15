From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature termination"
Date: Sun, 15 Jan 2017 11:41:51 -0800
Message-ID: <CA+55aFyyBf9SLSNDRqMcFbmUBBkbamZYXGOgfXU8k5KYaFD2mw@mail.gmail.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
 <20170115091925.GA26656@gmail.com> <1484496665.2405.2.camel@HansenPartnership.com>
 <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com> <1484507599.2405.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:34931 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751206AbdAOTlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Jan 2017 14:41:52 -0500
In-Reply-To: <1484507599.2405.16.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>

On Sun, Jan 15, 2017 at 11:13 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Can we compromise on "try not to revert a fix ...".

No.

It's about timing, and about how serious the regression is.

For example, if this happened in rc7, I would have reverted
immediately. No questions asked.

In this case, the "fix" was was also much less important then the
problem it caused. Some specialized pass-through command not working
right, vs a machine not even booting? There's just no question
what-so-ever.

So the "fix" you claim just wasn't nearly important enough. It was
also pretty recent and clearly things had worked for _years_ without
it.

In fact, I'm still somewhat inclined to revert it, just to have a
working rc4 release later today. But I'm hoping maybe Ingo has time to
test things (although I suspect he's already asleep).

               Linus
