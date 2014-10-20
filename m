From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Tue, 21 Oct 2014 07:34:30 +1300
Message-ID: <CAOmrzk+_pujcr_SPfijV5Z5fp057tkbtbZHq0URWFh9RKpNdUQ@mail.gmail.com>
References: <20141002065628.256592712@telegraphics.com.au>
	<20141002065633.766165263@telegraphics.com.au>
	<5444BAB7.5000908@gmail.com>
	<alpine.LNX.2.00.1410202217270.18012@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1410202217270.18012@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

>> not certain it is related to this exact patch - the driver crashes
>> pretty much on the spot when selecting the first target on the bus.
>
> If it isn't that exact patch then it will probably be one of the other
> atari_scsi patches. Most of the other relevant stuff was covered by my own
> testing.
>
> Anyway, thanks for testing and for sending the backtrace. I'll figure out
> what went wrong and fix it before I send a new patch set.

Let me know what I can do to help - e.g. can the platform device patch
be backed out without upsetting the rest of the series?

Cheers,

  Michael
