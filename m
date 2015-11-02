From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: Build regressions/improvements in v4.3
Date: Mon, 2 Nov 2015 12:27:48 +0100
Message-ID: <CAMuHMdV9_3j7y_6KtW1+Dc7+YrGP1Wcc0fZg7QTGuTafAk1v-g@mail.gmail.com>
References: <1446463587-28133-1-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446463587-28133-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: scsi <linux-scsi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 2, 2015 at 12:26 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v4.3[1] to v4.3-rc7[3], the summaries are:
>   - build errors: +4/-7

  + /home/kisskb/slave/src/drivers/scsi/advansys.c: error: implicit
declaration of function 'free_dma'
[-Werror=implicit-function-declaration]:  => 11384:3
  + /home/kisskb/slave/src/drivers/scsi/advansys.c: error: implicit
declaration of function 'request_dma'
[-Werror=implicit-function-declaration]:  => 11300:4

arm-randconfig

> [1] http://kisskb.ellerman.id.au/kisskb/head/9535/ (256 out of 254 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/9511/ (255 out of 254 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
