From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Sun, 18 Apr 2004 20:20:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418202022.B3393@infradead.org>
References: <20040418185950.GG4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:59399 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263928AbUDRTUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:20:23 -0400
Content-Disposition: inline
In-Reply-To: <20040418185950.GG4868@tpkurt.garloff.de>; from garloff@suse.de on Sun, Apr 18, 2004 at 08:59:50PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Sun, Apr 18, 2004 at 08:59:50PM +0200, Kurt Garloff wrote:
> 
> Feature.
> 
> scsi_allow_ghost_devices=N
> This patch introduces a boot/module parameter that allows the user to tell
> the kernel to NOT set the first N devices to offline despite they would
> normally be. Needed for some EMC multipathing devices.
> This parameter is even documented in EMC docs as both RH and SUSE had
> such a parameter in their 2.4 vendor kernels :-/

I'm very unhappy with that.  Could you explain why EMC needs this?
And even if we have to work around it I'd rather use the blacklist mechanism
for this.
