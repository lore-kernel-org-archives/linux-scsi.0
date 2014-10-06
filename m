From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 6 Oct 2014 10:36:21 +0200
Message-ID: <CAMuHMdWMJ5C7focerL-d1arsXH0jmhC4E1k-ggkmziA15Y=PEg@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065633.766165263@telegraphics.com.au>
	<CAMuHMdWmxEUMabRrbQpjhWTE1W4WD4CDkmXZNem06C0ScnKkFw@mail.gmail.com>
	<alpine.LNX.2.00.1410032054150.12643@nippy.intranet>
	<54308629.6060800@gmail.com>
	<alpine.LNX.2.00.1410061754280.26699@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1410061754280.26699@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 6, 2014 at 9:05 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
>> > > > +       if (IS_A_TT())
>> > > > +               instance->irq = IRQ_TT_MFP_SCSI;
>> > > > +       else
>> > > > +               instance->irq = IRQ_NONE;
>> > > >
>> > > platform_device resource?
>> > >
>> >
>> > If I thought it possible to parameterize the driver such that it never
>> > had to test IS_A_TT(), I'd probably agree that this would be more
>> > elegant.
>> >
>> > Otherwise I'd prefer not to have parts of the logic separated off into
>> > the platform resources while the remaining logic remains in the driver
>> > itself.
>> >
>> > While I don't think platform resources are desirable in this driver, I
>> > would like to hear Michael's views.
>> >
>>
>> The IRQ is a good candidate to be passed via platform data.
>
> Geert didn't say so, but after thinking about his review comments I
> imagine that he wants all the Atari IRQ numbers kept in one place and all
> the Mac IRQ numbers in a different place, and so on. Makes sense.

In the end, it's the same SCSI chip.

The "only" differences are resources, interrupts, DMA, and glue logic.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
