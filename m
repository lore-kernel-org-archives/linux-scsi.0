From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 2.6.9-rc2] add ability to set device queue depth to mptfusion
Date: Tue, 28 Sep 2004 11:48:14 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928114814.A794@infradead.org>
References: <20040928075846.GA190230@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:30995 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266705AbUI1Ks0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 06:48:26 -0400
Content-Disposition: inline
In-Reply-To: <20040928075846.GA190230@sgi.com>; from jeremy@sgi.com on Tue, Sep 28, 2004 at 12:58:47AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Emoore@lsil.com, linux-scsi@vger.kernel.org


Code looks good but some style nitpicks (often inherited from the original
code):

> +static void
> +mptscsih_set_queue_depth(struct scsi_device *device, MPT_SCSI_HOST *hd, VirtDevice *pTarget, int qdepth)

linebreaks after 80characters please.

> +	if ( hd->is_spi ) {

	if (hdis_spi) {

> +			else if (((pTarget->inq_data[0] & 0x1f) == 0x00)
> +			  && (pTarget->minSyncFactor <= MPT_ULTRA160 ))


			else if (!(pTarget->inq_data[0] & 0x1f) &&
				 (pTarget->minSyncFactor <= MPT_ULTRA160)

> +	}
> +	else

	} else

