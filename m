From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Sat, 5 Dec 2015 13:12:12 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512051246540.31458@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1449183781-2163-1-git-send-email-linux@rainbow-software.org> <CAGRGNgU=6=XBGxpwe+Z+uU-Pq-L=aTyG2GukkWAqFVnJHTY3Og@mail.gmail.com> <alpine.LNX.2.00.1512041857160.13680@nippy.intranet>
 <CAGRGNgVMOuWbeq8B-hrwtLvwdsVqdLV5UvCw8K6+JF5p0DHRoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <CAGRGNgVMOuWbeq8B-hrwtLvwdsVqdLV5UvCw8K6+JF5p0DHRoQ@mail.gmail.com>
Sender: linux-m68k-owner@vger.kernel.org
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Ondrej Zary <linux@rainbow-software.org>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On Sat, 5 Dec 2015, Julian Calaby wrote:

> Hi Finn,
> 
> On Fri, Dec 4, 2015 at 7:38 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
> >
> > On Fri, 4 Dec 2015, Julian Calaby wrote:
> >
> >> > -               if (overrides[current_override].board == BOARD_NCR53C400A) {
> >> > +               if (overrides[current_override].board == BOARD_NCR53C400A ||
> >> > +                   overrides[current_override].board == BOARD_DTC3181E) {
> >>
> >> These if statements are starting to get a bit long, would it make
> >> sense to replace them with a flag or equivalent?
> >
> > To what end? Shorter lines? As in,
> 
> Pretty much, each expression is quite long and they seem to be growing 
> fairly rapidly as you and Ondrej discover similar boards.

Each BOARD_* macro actually refers to a whole category of devices. No new 
boards, devices or categories of devices have been discovered.

Ondrej is enabling and/or fixing PDMA functionality for three existing 
device categories, for which the driver already has a nominally compatible 
PDMA implementation.

-- 
