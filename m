From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 00/36] Fixes, cleanups and modernization for NCR5380 drivers
Date: Wed, 5 Nov 2014 09:10:18 +0100
Message-ID: <CAMuHMdV_xAdXB-0Q=qCGqDKt9uY7LT5mn_DXKZiA1aVmcuMOLA@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<5455C107.6040500@gmail.com>
	<alpine.LNX.2.00.1411021710210.27266@nippy.intranet>
	<5455E340.7080305@gmail.com>
	<CAOmrzkKVYBcznyEaUX7Ta9z3P+B9=BTSj3kCZTjx-euZ2gannQ@mail.gmail.com>
	<CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53034 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaKEIKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 03:10:20 -0500
In-Reply-To: <CAL4YKD5fqhZKZG3_cOTxasqTSdb5oC3g0aUKnnxzE3Q4MJyxGQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?David_G=C3=A1lvez?= <dgalvez75@gmail.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, aniplay@wanadoo.fr

On Wed, Nov 5, 2014 at 8:56 AM, David G=C3=A1lvez <dgalvez75@gmail.com>=
 wrote:
> Do you know about the Falcon's disturbance in the SDMA clock signal
> hardware problem?
> Most Falcons, specially those used in music studios, have a hardware
> patch to fix this, it's normally called SCSI patch.
>
> Some more info:
>
> http://didierm.pagesperso-orange.fr/doc/eng/c_0a.htm

So this adds additional buffering to the clock.

Note that input pins 3 and 5 of the 74HC04 are left floating!
I recommend tying them to either GND (pin 7) or VCC (pin 14), to avoid
them picking up high-frequency signals and consuming power.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
                                -- Linus Torvalds
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
