From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Sun, 9 Nov 2014 11:33:18 +0100
Message-ID: <CAMuHMdVK1pa-XyxaHK_xs2RBjYpYkKGT3KwkNy8NFLS=bfgm_g@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<5455C107.6040500@gmail.com>
	<alpine.LNX.2.00.1411021710210.27266@nippy.intranet>
	<5455E340.7080305@gmail.com>
	<CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
	<CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com>
	<CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com>
	<CAOmrzkLW+cRi1p7Wa63L-Tf-hCtVkkcFxGmqQVBQHL4A3F+hKQ@mail.gmail.com>
	<alpine.LNX.2.00.1411061507240.20750@nippy.intranet>
	<CAOmrzkKUXJaDh7gchStxkwMeR6MUDGZPD+O+iAsvSbQOT0yB2g@mail.gmail.com>
	<alpine.LNX.2.00.1411071332540.1026@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1411071332540.1026@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, =?UTF-8?Q?David_G=C3=A1lvez?= <dgalvez75@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Fri, Nov 7, 2014 at 3:34 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> it's probably not Geert but James who needs to give the go-ahead.
>
> Given Geert's objections to the changes under arch/m68k in v1, I'm hoping
> for an acked-by from Geert for v2...

I'm happy with the arch/m68k changes in v2 (modulo the PAGE_SIZE
comment on Sun-3), so please add my
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
after fixing that one.
As I'm not afraid of merge conflicts, I think this can go in through the SCSI
tree? James?

Note that there's still room for improvement in the individual drivers, using
more modern infrastructure (e.g. using devm_*() calls, and getting rid of the
multiple ATARIHW_PRESENT() checks using e.g. platform_data or regmap).
But this is already a giant step forward.

Thanks a lot for doing this cleanup!
Removing ca. 3700 LoC deserves you a spot in the LoC removal Hall of Fame!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
