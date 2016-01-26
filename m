From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Tue, 26 Jan 2016 12:13:20 +0100
Message-ID: <CAMuHMdWNRM88KQRLsKfzbNFJChjVu-jR26jr7S2193p2wRGNCg@mail.gmail.com>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050510.031796194@telegraphics.com.au>
	<CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com>
	<alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
	<CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
	<alpine.LNX.2.00.1601261117280.15080@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1601261117280.15080@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

On Tue, Jan 26, 2016 at 1:18 AM, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Mon, 25 Jan 2016, Geert Uytterhoeven wrote:
>> > In principle I think that Linux drivers should not carry workarounds
>> > for emulators.
>>
>> Please consider ARAnyM is the current m68k workhorse, so it would be
>> nice to handle this someway.
>
> AFAICT atari_scsi on aranym never did anything useful. Those aranym users
> who need to run Linux 4.5 can set CONFIG_ATARI_SCSI=n or blacklist the
> atari_scsi module (up until aranym can be patched).

FTR. adding "initcall_blacklist=atari_scsi_driver_init" to the kernel command
line makes it boot again.

>> Alternatively, we need to fix ARAnyM,
>
> I'll look into writing a patch for the emulator after I've finished
> testing the exception handling fixes for the driver.

Thank you!

>> or can make the creation of the atari_scsi platform device conditional
>> on not running under ARAnyM.
>
> Fixing the emulator is the only sensible approach. If S operating systems
> have to carry workarounds for B emulator bugs, the cost is (at least)
> proportional to S * B.

Sure.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
