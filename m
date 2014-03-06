From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 1/3] m68k/atari - convert atari_scsi falcon_get_lock() to
 use wait_event()
Date: Thu, 6 Mar 2014 14:48:12 +0100
Message-ID: <CAMuHMdUm_FrhnagZcDBGFH15tqSfC5We0fczSbRhmbyi1KvHZQ@mail.gmail.com>
References: <1393660265-19384-1-git-send-email-schmitz@debian.org>
	<1393660265-19384-2-git-send-email-schmitz@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50702 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaCFNsN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2014 08:48:13 -0500
In-Reply-To: <1393660265-19384-2-git-send-email-schmitz@debian.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Schmitz <schmitz@debian.org>

On Sat, Mar 1, 2014 at 8:51 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
> sleep_on is known broken and going away. The atari_scsi driver is one of
> two remaining users in the falcon_get_lock() function, which is a rather
> crazy piece of code. This does not attempt to fix the driver's locking
> scheme in general, but at least prevents falcon_get_lock from going to
> sleep when no other thread holds the same lock or tries to get it,
> and we no longer schedule with irqs disabled.
>
> MSch: fixed completion conditions missed in Arnds' original RFC patch.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Michael Schmitz <schmitz@debian.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org

Thanks, applied with original authorship attribution, original subject
matching SCSI oneline summary style, and proper SoB.

Will queue for 3.15.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
