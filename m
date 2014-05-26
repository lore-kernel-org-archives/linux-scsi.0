From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 26 May 2014 13:15:22 +1200
Message-ID: <CAOmrzkK-jDF7h_HLH=8qPTs+eevFf5-S_dDTfD2P2BZ6hxcW0Q@mail.gmail.com>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>
	<CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>
	<CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com>
	<20140413.221414.853080853067673824.davem@davemloft.net>
	<534B6C9E.3070307@aalto.fi>
	<529ac1e986ffc7a0c361a7f758e0abc3@gmail.com>
	<CAMuHMdVWNh8511ThemX6DqvwCabRw4iqcg863CqgtC1FvOPJ8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52442 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbaEZBPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 21:15:24 -0400
In-Reply-To: <CAMuHMdVWNh8511ThemX6DqvwCabRw4iqcg863CqgtC1FvOPJ8A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tuomas Vainikka <tuomas.vainikka@aalto.fi>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, David Miller <davem@davemloft.net>, Kars de Jong <jongk@linux-m68k.org>

Hi Geert,

> [sorry for the long delay]

Tell me about it :-) I haven't had a good idea how to address this
problem so rather kept mum about it.

> On Mon, Apr 14, 2014 at 10:51 AM, Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Not sure my patch had ever made it into Geert's m68k-queue - except for the
>> patch in my previous mail, my zorro_esp.c is still the same as I got from
>> you in October last year. The project has been on the back burner for too
>> long ...
>
> I don't think it makes much sense to add it to my queue, as it's purely SCSI
> and not critical for current m68k.

Fine, Ill try and resolve that with Dave then. Tuomas will need to do
the testing (unless someone wants to drop off the necessary hardware
with me - unlikely).

Thanks,

  Michael
