From: Kars de Jong <jongk@linux-m68k.org>
Subject: Re: esp_scsi QTAG in FAS216
Date: Thu, 10 Apr 2014 16:31:54 +0200
Message-ID: <CACz-3rg3LNFKNPUNwc1OF_O_b5k=28hw8Nj50dWhxy4A5_QbVg@mail.gmail.com>
References: <CAOmrzkKP4YcvnHcrtucMvS9WSaeg+6-qnobOWN6hBK=wkUHemg@mail.gmail.com>
	<CAMuHMdUH=9sv-Vb3ZTAGyfvEQOO0x0x1cUYhfd7040k8d+bSYg@mail.gmail.com>
	<5231DF69.6070807@aalto.fi>
	<20140404.162830.1700547572091852195.davem@davemloft.net>
	<CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAOmrzkL_6Y2RhpKANmTEWL53-6Ts+PF9Hhk_4Fh1s0wx7f_NhQ@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: David Miller <davem@davemloft.net>, Tuomas Vainikka <tuomas.vainikka@aalto.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2014-04-06 22:33 GMT+02:00 Michael Schmitz <schmitzmic@gmail.com>:
>
> Hello Dave, Tuomas,
>
> >> Also, looking at the timeout formulae in the old NCR53C9x.c driver,
> >> the values would be different for FAS216. Why was this dropped from
> >> the modern esp_scsi?
> >
> > I've never seen a formula for any ESP or FAS chip for the timeout
> > other than the one mentioned in huge comment in
> > esp_set_clock_params(), although I do see the 7668 instead of 8192
> > factor being used in the old NCR53C9x driver.
>
> I haven't gone far enough back in the 53C9x revision history to be
> certain. but it would seem to me that Kars de Jong added that FAS
> special case.
>
> Can you confirm that, Kars? Any recollection as to the reason?

That is the value that's in the data manual of the Symbios Logic
SYM53CF94/96-2 (the actual chip that's in my Amiga SCSI controller).

Funny, according to the QLogic FAS2x6 manual the value should be 7682
for FAS216/216U/236/236U chips...

I don't think it's all that important. It only means that the actual
selection timeout used by the chip will be slightly shorter than it is
supposed to be.


Kind regards,

Kars.
