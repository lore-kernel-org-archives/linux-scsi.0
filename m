From: Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH] drivers/scsi/arm/acornscsi.c: rename CONFIG_ACORNSCSI_CONSTANTS
Date: Tue, 28 Apr 2015 21:57:45 +0200
Message-ID: <CAD3Xx4LbR3tAo4V0-Ln6cR=h2dHvfycVdgdy1VEdO+4bo4UJ1A@mail.gmail.com>
References: <1430230511-10869-1-git-send-email-valentinrothberg@gmail.com>
 <1430248224.2411.68.camel@x220> <CAD3Xx4LMZudtWBajjpNgLjXbCKmiAq9YyMZwMNn=5=5w_1vCPQ@mail.gmail.com>
 <1430249682.2411.79.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430249682.2411.79.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: JBottomley@odin.com, linux@arm.linux.org.uk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 28, 2015 at 9:34 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> Hi Valentin,
>
> On Tue, 2015-04-28 at 21:26 +0200, Valentin Rothberg wrote:
>> On Tue, Apr 28, 2015 at 9:10 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> > Will the Erlangen bot still spot ACORNSCSI_CONSTANTS as a potential
>> > issue?
>>
>> No, undertaker-checkpatch won't complain about this.  There are
>> thousands of such cases (i.e., without CONFIG_ prefix) around in the
>> code (mostly #ifdef DEBUG).  But most of them are intentionally dead
>> or related to debugging, so they are ignored to avoid having false
>> positives.
>
> Well, in a few years time, once undertaker-checkpatch has stomped out
> most of the faux Kconfig preprocessor checks, that might be an area to
> cover too. Or is that issue, ie pointless preprocessor checks, harder
> than one might naively think?

To give a number from Linus' tree today: 4706 of such unprefixed dead
and undead #ifdefs and 940 'real' ones.  Most of them are intentional
-- this doesn't mean that it's not a problem.  Personally, I don't
like to have code around that cannot at least be easily test compiled;
 we manually need to (un)define the identifiers.

I like your proposal.  For symbolic issues, we could even put that
directly in checkkconfigsymbols.py, so a big part of the problem could
be solved directly with Kernel tools.  But I really hope that it won't
take a few years until we get there : )

 Valentin

> Thanks,
>
>
> Paul Bolle
>
