From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 25/36] sun3_scsi: Convert to platform device
Date: Sun, 9 Nov 2014 13:18:47 +0100
Message-ID: <CAMuHMdWCEDP=vbHt3UC5nxN-yxw-6w45kUZksh2=ijVjZ0eM6w@mail.gmail.com>
References: <20141027052607.105914311@telegraphics.com.au>
	<20141027052613.155430175@telegraphics.com.au>
	<CAMuHMdUULx29rmrSPxmSJugTQAbRVnkcjVzg6j3-eN4U7hLpZA@mail.gmail.com>
	<alpine.LNX.2.00.1411092312040.21822@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1411092312040.21822@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Michael Schmitz <schmitzmic@gmail.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Nov 9, 2014 at 1:12 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> According to the Sun-3 Architecture Manual v2.0 (May 1985), end should
>> be 0x0014001f.
>
> OK. Where did you find that, BTW?

In my local collection of hardware docs I downloaded eons ago ;-)
Fortunately it hasn't disappeared from the Internet, unlike many others docs
I've collected over the years:

https://www.google.be/search?q=Sun-3_Architecture_Manual_Ver_2.0_May85.pdf

>> I guess the resource length is 0x20 for VME SCSI, too?
>
> For VME SCSI it would need to be 8 + sizeof(struct sun3_dma_regs) which I
> think equals 0x22:

IC.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
