From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 23/29] atari_scsi: Convert to platform device
Date: Mon, 20 Oct 2014 22:22:00 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1410202217270.18012@nippy.intranet>
References: <20141002065628.256592712@telegraphics.com.au> <20141002065633.766165263@telegraphics.com.au> <5444BAB7.5000908@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <5444BAB7.5000908@gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Sam Creasey <sammy@sammy.net>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org


On Mon, 20 Oct 2014, Michael Schmitz wrote:

> Hi Finn,
> 
> not certain it is related to this exact patch - the driver crashes 
> pretty much on the spot when selecting the first target on the bus.

If it isn't that exact patch then it will probably be one of the other 
atari_scsi patches. Most of the other relevant stuff was covered by my own 
testing.

Anyway, thanks for testing and for sending the backtrace. I'll figure out 
what went wrong and fix it before I send a new patch set.

-- 
