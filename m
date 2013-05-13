From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH RESEND 2/2] [SCSI] a3000: use module_platform_driver_probe()
Date: Mon, 13 May 2013 11:28:57 +0200
Message-ID: <CAMuHMdWJAma-giQwvAiGidqWoGDT59pa6R+ziGXVuPjwTf5mNg@mail.gmail.com>
References: <000e01ce46fe$8b81cc20$a2856460$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:39232 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab3EMJ26 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 May 2013 05:28:58 -0400
Received: by mail-ie0-f180.google.com with SMTP id ar20so12000774iec.11
        for <linux-scsi@vger.kernel.org>; Mon, 13 May 2013 02:28:57 -0700 (PDT)
In-Reply-To: <000e01ce46fe$8b81cc20$a2856460$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jingoo Han <jg1.han@samsung.com>
Cc: James Bottomley <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>

On Thu, May 2, 2013 at 8:30 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> This patch uses module_platform_driver_probe() macro which makes
> the code smaller and simpler.
>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

James, will you take this one? Or shall I queue it in the m68k tree?
Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
