From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] Generic SCSI Target Middle Level for Linux (SCST) with target drivers
Date: Thu, 17 Jun 2004 13:22:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040617122213.GA30943@infradead.org>
References: <40D075DA.2000007@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:43178 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S266466AbUFQMWQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jun 2004 08:22:16 -0400
Content-Disposition: inline
In-Reply-To: <40D075DA.2000007@vlnb.net>
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jun 16, 2004 at 08:31:22PM +0400, Vladislav Bolkhovitin wrote:
> In the current version 0.9.1 SCST looks to be quite stable (for beta)
> and useful. The same is for Qlogic 2200/2300 target driver. Only 2.4
> kernels currently supported, but update for 2.6 is coming soon. No
> kernel patches are necessary. Tested on i386 only, but should work on
> any other supported by Linux platform.
> 
> More information, including the source code and detail documentation, 
> could be found on http://scst.sf.net.
> 
> Any comments would be appreciated.

The code looks pretty neat to me, there's a few issues I'd like to see
addresses but that doesn't make sense before the 2.4 support is dropped
and there's an actual LLDD for 2.6.  But I think for most interesting
scenarios in the storage virtualization world your driver is pretty much
useless because it wants to dispatch directly to a scsi device and doesn't
go through the block layer.  So no fancy volume managers/etc there to make
interesting storage virtualization boxes.

