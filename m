From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] initio: Convert into a real Linux driver and update to modern style
Date: Mon, 21 May 2007 16:34:33 +0100
Message-ID: <20070521153433.GA26686@infradead.org>
References: <20070521150643.3fdc3b6e@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58878 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbXEUPef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2007 11:34:35 -0400
Content-Disposition: inline
In-Reply-To: <20070521150643.3fdc3b6e@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, James Bottomley <James.Bottomley@SteelEye.com>

On Mon, May 21, 2007 at 03:06:43PM +0100, Alan Cox wrote:
> This is a mix of a grand clean up I did and a reworking of the hotplug
> support by Christoph. In testing it works as well as the previous code
> did (that is -quite badly-) but we can now read it and as it settles in
> actually debug the long standing problems it shares with the old driver.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> (Wants a signed-off-by from Christoph)


Signed-off-by: Christoph Hellwig <hch@lst.de>

removal of the BSD license is also fine with me, but should really
get a mention in the changelog aswell.

