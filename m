From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] unique_id for ide-scsi
Date: Mon, 9 Feb 2004 16:06:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209160605.B23604@infradead.org>
References: <20040209155440.GQ3944@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:60944 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263448AbUBIQGI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Feb 2004 11:06:08 -0500
Content-Disposition: inline
In-Reply-To: <20040209155440.GQ3944@tpkurt.garloff.de>; from garloff@suse.de on Mon, Feb 09, 2004 at 04:54:40PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Willem Riede <osst@riede.org>, James Bottomley <James.Bottomley@steeleye.com>

On Mon, Feb 09, 2004 at 04:54:40PM +0100, Kurt Garloff wrote:
> Hi,
> 
> most scsi host adapters do fill in their ioport into thos host's 
> unique_id field.
> ide-scsi does not. The attached patch changes it.
> 
> Caveats: It puts the first PATA port there, the SATA port are not
>  considered. Are there SATA chips that don't have PATA ports?

What do you need this for?  I'd prefer to completly nuke unique_id in
2.7.<early>

