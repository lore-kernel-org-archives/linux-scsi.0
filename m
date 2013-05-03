From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH -next 2/2] sun3_scsi: switch to ->show_info()
Date: Fri, 3 May 2013 22:03:43 +0200
Message-ID: <CAMuHMdWEMT8FWaByiBh+Y2qhwWyqT4JyVZmLsCEYv30v2qM4yg@mail.gmail.com>
References: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
	<1365594729-25759-2-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1365594729-25759-2-git-send-email-geert@linux-m68k.org>
Sender: linux-next-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linux-Next <linux-next@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Ping?

Now the build failure is also in Linus' tree:

http://kisskb.ellerman.id.au/kisskb/buildresult/8674437/

BTW, this patch depends on "[PATCH 1/2] sun3_scsi: Fill in missing
scsi_host_template.proc_info method"

On Wed, Apr 10, 2013 at 1:52 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Based on Al's changes to atari_scsi.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/8543326/
>
>  drivers/scsi/sun3_NCR5380.c |  185 ++++++++++++++++++------------------------
>  drivers/scsi/sun3_scsi.c    |    2 +-
>  drivers/scsi/sun3_scsi.h    |    2 +-
>  3 files changed, 81 insertions(+), 108 deletions(-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
