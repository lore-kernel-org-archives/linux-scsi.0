From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] target fixes for v4.11-rc7
Date: Tue, 11 Apr 2017 23:55:28 -0700
Message-ID: <CA+55aFyn1matXDTkeDA1d2+tHBSVkBvS5kP-7Ngh86=uut+yyg@mail.gmail.com>
References: <1491972461.8231.114.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1491972461.8231.114.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2017 at 9:47 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> Hi Linus,
>
> Here are the outstanding target-pending bug-fixes for v4.11-rc7.

So I'm pulling this, but I'm getting real tired of this crap. We're
late in the rc's, I shouldn['t be getting pull requests of hundreds of
lines any more.

A lot of these fixes look like things that HAVE NEVER WORKED.

If something has never worked, it damn well isn't a "fix" any more,
it's actual real development. It should go in the development branch.

The rc stuff is for regressions, and for things that actually are
nasty problems (security, keeping people from getting work done).

The rc stuff is *not* supposed to be development of stuff that has
ever worked before. That's *new* code, not a bugfix.

                    Linus
