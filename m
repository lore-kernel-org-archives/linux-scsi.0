From: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v3 00/77] More fixes, cleanup and modernization for NCR5380 drivers
Date: Tue, 22 Dec 2015 21:14:30 +0100
Message-ID: <201512222114.33005.linux@rainbow-software.org>
References: <20151222011737.980475848@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011737.980475848@telegraphics.com.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 22 December 2015 02:17:38 Finn Thain wrote:
> 
> Like my previous work on the NCR5380 drivers, this patch series has bug
> fixes, code cleanup and modernization. These drivers suffer from mistakes,
> poor style and neglect and this long series addresses the worst of it,
> covering all ten wrapper drivers and both of the core driver forks. The
> combined size of the drivers is reduced by over 700 LoC.
> 
> This series continues to reduce divergence between the two core driver
> forks, often by copying a bug fix from one to the other. Most patches are
> larger for having to keep the two forks in sync. Making the same change to
> both is churn if one of them is to be removed but neither can be as yet.
> By the end of this series the diff between the two forks is minimal, so it
> becomes clear what caused the fork and what can be done about it.
> 
> This patch series did benefit from scripts/checkpatch.pl but not too much.
> Decades ago, these drivers started out with 4-space tabs and if the 80
> column limit were to be strictly enforced now, it would require adding new
> functions and shortening identifiers. I would defer this sort of activity
> until after the fork has been resolved.
> 
> All patches to all NCR5380 drivers (x86, ARM, m68k) have been compile-
> tested. The mac_scsi, dmx3191d, g_NCR5380 and atari_scsi modules were
> regression tested on suitable hardware.

Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip) and DTC-3181L (DTCT-436P chip) ISA cards - everything works fine!

Thanks.

Tested-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary
