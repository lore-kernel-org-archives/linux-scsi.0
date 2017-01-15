From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Revert "scsi: mpt3sas: Fix secure erase premature termination"
Date: Sun, 15 Jan 2017 10:54:14 -0800
Message-ID: <CA+55aFweyFstUaKGdg6A9p65URrzZAJNBCF8ou0MfKb4EPL=Rw@mail.gmail.com>
References: <1484319727.2527.8.camel@HansenPartnership.com>
 <20170115091925.GA26656@gmail.com> <1484496665.2405.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484496665.2405.2.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jan 15, 2017 at 8:11 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> We're not reverting a fix that would cause regressions for others.

Oh HELL YES we are.

The rule is that we never break old stuff. Some new fix that fixes
something that never used to work, but breaks something else, gets
reverted very aggressively.

So if a new bugfix or workaround causes problems for existing users,
it gets reverted. The fact that it fixed something else is COMPLETELY
IRRELEVANT.

We do not do the "one step forward, two steps back" dance. If you
can't fix a bug without breaking old systems, the "fix" gets reverted.

Apparently there is already a possible real fix in flight, so I won't
actually do the revert, but I very much want to object to your
statement.

Reverts happen.

            Linus
