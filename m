From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Tue, 18 Mar 2014 06:20:27 -0700
Message-ID: <1395148827.2812.54.camel@joe-AO722>
References: <20140318002822.372705594@telegraphics.com.au>
	 <1395112756.20860.1.camel@joe-AO722>
	 <alpine.LNX.2.00.1403182208590.2018@nippy.intranet>
	 <1395146702.2812.47.camel@joe-AO722>
	 <CAMuHMdUMpdp7deL5zC4hUVTHjyNbtkZ2bNFupo5JiDyuyc345w@mail.gmail.com>
	 <1395148051.2812.51.camel@joe-AO722>
	 <CAMuHMdVxTQDdpcdjZZRSrvT8cmuT2AkE1q6WaSWey8U+PuVX2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdVxTQDdpcdjZZRSrvT8cmuT2AkE1q6WaSWey8U+PuVX2w@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@parallels.com>, scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2014-03-18 at 14:13 +0100, Geert Uytterhoeven wrote:
> > no_printk keeps all side effects like
> > performing any function calls made by the
> > statement or accessing any volatiles.
> That's true...
> > Using
> > do { if (0) no_printk(fmt, ##__VA_ARGS__); } while (0)
> > does not have any side-effects.
> ... but all current users in include/ have the side-effects.

I believe that's intentional, but <shrug>.

I prefer debug statements to have _no_
side effects when not compiled-in/enabled.

Opinions vary.

cheers, Joe
