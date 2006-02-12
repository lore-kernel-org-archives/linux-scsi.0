From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Plextor PowerRec for users
Date: Sun, 12 Feb 2006 09:53:27 -0700
Message-ID: <20060212165327.GG12822@parisc-linux.org>
References: <200602121718.15200.T.Maguin@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:28370 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750741AbWBLQx3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Feb 2006 11:53:29 -0500
Content-Disposition: inline
In-Reply-To: <200602121718.15200.T.Maguin@web.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Maguin <T.Maguin@web.de>
Cc: linux-scsi@vger.kernel.org

On Sun, Feb 12, 2006 at 05:18:04PM +0100, Thomas Maguin wrote:
> Blame on me, a typo in the addresses. Changes should be this:
> (patch is on the way)
> 
> /usr/src/linux/include/scsi/scsi.h
> +#define PLEXTOR_MODE ?? ?? ?? ?? ?? ?? ?? ?? ??0xe9
> +#define PLEXTOR_PREC_SPEEDS ?? 0xeB
> +#define PLEXTOR_MODE2 ?? ?? ?? ?? ?? ?? ?? ??0xeD
> 
> /usr/src/linux/block/scsi/scsi_ioctl.c
> +safe_for_read(PLEXTOR_MODE)
> +safe_for_read(PLEXTOR_PREC_SPEEDS)
> +safe_for_read(PLEXTOR_MODE2)

The trouble is that these are vendor-specific commands.  So they're safe
*for plextor devices*, but they may well be unsafe for other vendors.
Given the LG CD-ROM snafu [1], I'd expect people to err on the side
of caution.  Sorry.

[1] http://www.dvd-recordable.org/Article911-mode=thread-order0-threshold0.phtml


