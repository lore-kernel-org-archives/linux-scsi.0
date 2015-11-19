From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380 drivers
Date: Thu, 19 Nov 2015 08:48:21 +0100
Message-ID: <201511190848.21475.linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au> <201511181235.15663.linux@rainbow-software.org> <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1511191321010.9967@nippy.intranet>
Content-Disposition: inline
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thursday 19 November 2015, Finn Thain wrote:
> On Wed, 18 Nov 2015, Ondrej Zary wrote:
> > On Wednesday 18 November 2015, Finn Thain wrote:
> > > Like my previous work on the NCR5380 drivers, this patch series has
> > > bug fixes, code cleanup and modernization. These drivers suffer from
> > > mistakes, poor style and neglect and this long series addresses the
> > > worst of it, covering all ten wrapper drivers and both of the core
> > > driver forks. The combined size of the drivers is reduced by about 750
> > > LoC.
> > >
> > > This series continues to reduce divergence between the two core driver
> > > forks, often by copying a bug fix from one to the other. Most patches
> > > are larger for having to keep the two forks in sync. Making the same
> > > change to both is churn if one of them is to be removed but neither
> > > can be as yet. By the end of this series the diff between the two
> > > forks is minimal, so it becomes clear what caused the fork and what
> > > can be done about it.
> > >
> > > This patch series did benefit from scripts/checkpatch.pl but not too
> > > much. Decades ago, these drivers started out with 4-space tabs and if
> > > the 80 column limit were to be strictly enforced now, it would require
> > > adding new functions and shortening identifiers. I would defer this
> > > sort of activity until after the fork has been resolved.
> > >
> > > I have compile-tested all patches to all NCR5380 drivers (x86, ARM,
> > > m68k) and regression tested mac_scsi and dmx3191d modules on suitable
> > > hardware. Testing the mac_scsi and dmx3191d modules provides only
> > > limited coverage. It would be good to see some testing of ISA cards
> > > and Sun 3 and Atari hardware too (I don't have any).
> >
> > I have some NCR5380 ISA cards and can test them.
>
> Thanks Ondrej. I've no idea which ISA drivers are presently working in
> mainline. Finding regressions may be more difficult than usual ;-)

I remember that at least one of them never worked in Linux - HP C2502 card 
with 53C400A chip with no jumpers (magic-numbers-based configuration).

The memory-mapped Canon FG2-5202 (53C400) did not work properly either.

At least DTCT-436P used to work.

-- 
Ondrej Zary
