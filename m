From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sun, 6 Feb 2005 17:33:16 +0000
Message-ID: <20050206173316.GA2589@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C12EB2A@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from pentafluge.infradead.org ([213.146.154.40]:15790 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261247AbVBFRdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 12:33:20 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB2A@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: vst@vlnb.net, linux-scsi@vger.kernel.org

On Sun, Feb 06, 2005 at 12:28:17PM -0500, James.Smart@Emulex.Com wrote:
> Since the Emulex driver tracks things by target (actually FC remote port)
> rather than luns, having the ability to have driver data space in the
> lun didn't help much. Yes, the driver data space could be in the
> transport-specific FC remote port, but I thought a more generic solution
> would have been prefered - thus the patch request.
> 
> At this point, it appears that consensus is against the need for this,
> especially as it can be handled within the only area needed today - that of
> the FC transport.

Well, I disagree with that for certain.  I know of a handfull of SPI
HBA drivers that would benefit from per-target private data.

