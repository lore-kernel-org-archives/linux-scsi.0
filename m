From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] target_core_alua: silence GCC warning
Date: Wed, 19 Feb 2014 10:59:19 +0100
Message-ID: <CAMuHMdXZrw7oU=n60+PNNQftU6Su=mBf2V75TCO8Ws1pS5z+6Q@mail.gmail.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
	<1392803546.27558.16.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1392803546.27558.16.camel@x220>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2014 at 10:52 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> -               ret = core_alua_state_nonoptimized(cmd, cdb,
> -                                       nonop_delay_msecs, &alua_ascq);
> +               core_alua_state_nonoptimized(cmd, cdb, nonop_delay_msecs);

I suggest making core_alua_state_nonoptimized()  return void, too.
Currently it always returns zero.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
