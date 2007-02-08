From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic79xx: use dma_get_required_mask()
Date: Wed, 07 Feb 2007 19:27:59 -0500
Message-ID: <1170894479.11400.4.camel@mulgrave.il.steeleye.com>
References: <45C99230.5020309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60026 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933350AbXBHA2M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 19:28:12 -0500
In-Reply-To: <45C99230.5020309@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

On Wed, 2007-02-07 at 09:47 +0100, Hannes Reinecke wrote:
> +	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;

Actually there's no need for this ... the mask_39bit references can just
become DMA_39BIT_MASK constants.  I made this cosmetic change to the
patch.

James


