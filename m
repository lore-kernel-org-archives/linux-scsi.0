From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Tue, 26 Jan 2016 11:18:18 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1601261117280.15080@nippy.intranet>
References: <20160103050501.042035135@telegraphics.com.au> <20160103050510.031796194@telegraphics.com.au> <CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com> <alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
 <CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 25 Jan 2016, Geert Uytterhoeven wrote:

> > In principle I think that Linux drivers should not carry workarounds 
> > for emulators.
> 
> Please consider ARAnyM is the current m68k workhorse, so it would be 
> nice to handle this someway.

AFAICT atari_scsi on aranym never did anything useful. Those aranym users 
who need to run Linux 4.5 can set CONFIG_ATARI_SCSI=n or blacklist the 
atari_scsi module (up until aranym can be patched).

> 
> Alternatively, we need to fix ARAnyM,

I'll look into writing a patch for the emulator after I've finished 
testing the exception handling fixes for the driver.

> or can make the creation of the atari_scsi platform device conditional 
> on not running under ARAnyM.

Fixing the emulator is the only sensible approach. If S operating systems 
have to carry workarounds for B emulator bugs, the cost is (at least) 
proportional to S * B.

-- 
