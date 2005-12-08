From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: potential initialisation problem in the aic94xx
Date: Thu, 8 Dec 2005 13:22:37 -0700
Message-ID: <20051208202237.GA9286@parisc-linux.org>
References: <1133214768.3325.66.camel@mulgrave> <1133842933.3282.7.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:18606 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932340AbVLHUWk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 15:22:40 -0500
Content-Disposition: inline
In-Reply-To: <1133842933.3282.7.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Dec 05, 2005 at 11:22:13PM -0500, James Bottomley wrote:
> Therefore, we have a serious bug in the aic94xx driver init code.  It's
> clearly relying on something to set it up correctly in the BIOS rather
> than doing everything in the driver init routine.  This means (unless
> corrected) that the card will only work on x86 like platforms.

... and it won't work when hotplugged, even on an x86 platform.
