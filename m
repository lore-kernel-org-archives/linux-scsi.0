From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 5/6: scsi_inq_timeout
Date: Sun, 18 Apr 2004 20:21:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040418202109.C3393@infradead.org>
References: <20040418185957.GH4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:61191 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263954AbUDRTVK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Apr 2004 15:21:10 -0400
Content-Disposition: inline
In-Reply-To: <20040418185957.GH4868@tpkurt.garloff.de>; from garloff@suse.de on Sun, Apr 18, 2004 at 08:59:57PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>

On Sun, Apr 18, 2004 at 08:59:57PM +0200, Kurt Garloff wrote:
> +#ifdef __powerpc64__
> +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+25;
> +#else
> +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
> +#endif

Huh?  per-arch ifdefs in the scsi code are completely bogus.

