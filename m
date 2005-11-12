From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] removed useless SCSI_GENERIC_NCR5380_MMIO
Date: Sat, 12 Nov 2005 18:20:25 +0000
Message-ID: <1131819625.18258.16.camel@localhost.localdomain>
References: <20051112043707.GX5376@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from clock-tower.bc.nu ([81.2.110.250]:13263 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S932433AbVKLRvG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Nov 2005 12:51:06 -0500
In-Reply-To: <20051112043707.GX5376@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Sad, 2005-11-12 at 05:37 +0100, Adrian Bunk wrote:
> This patch removes the useless SCSI_GENERIC_NCR5380_MMIO.
> 
> It's useless, since SCSI_G_NCR5380_MEM != CONFIG_SCSI_G_NCR5380_MEM.
> 
> This issue exists at least since kernel 2.6.0 and since it seems noone 
> noticed it I'd say we can safely remove it.


Its a one line bugfix so make the bugfix. There are often drivers that
needed tiny fixes and it turned out that

- Vendors had it in their patch tree for years
- The one person using it fixed it and didnt bother telling l/k cos they
though l/k was full of arrogant assholes who would just laugh at them
- The few users are still on 2.4 but will move to 2.6

Now when its a major rewrite to fix up some prehistoric piece of crap it
makes sense to dump it if nobody uses it, when you have a one line fix
required its a bit daft not to fix it.

Alan
