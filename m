From: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: [PATCH v4 34/78] atari_NCR5380: Use arbitration timeout
Date: Mon, 25 Jan 2016 19:28:22 +0100
Message-ID: <87h9i1ms3d.fsf@igel.home>
References: <20160103050501.042035135@telegraphics.com.au>
	<20160103050510.031796194@telegraphics.com.au>
	<CAMuHMdXKDwfEE0J2xjan2vhO3gyfBwaeRMa3Vh4-ewUrW61pvA@mail.gmail.com>
	<alpine.LNX.2.00.1601251109090.24503@nippy.intranet>
	<CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVevVnEa=ZgThGMObv--5zoOxvXXEPP9fe00Z1sPQHbhQ@mail.gmail.com>
	(Geert Uytterhoeven's message of "Mon, 25 Jan 2016 09:05:09 +0100")
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Alternatively, we need to fix ARAnyM, or can make the creation of the
> atari_scsi platform device conditional on not running under ARAnyM.

Given the ncr5380 emulation in ARAnyM is just a stub, making it less a
stub would be preferred.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
