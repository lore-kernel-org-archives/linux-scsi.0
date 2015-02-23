From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/43] hpsa: hpsa decode sense data for io and tmf
Date: Mon, 23 Feb 2015 12:18:02 -0800
Message-ID: <20150223201802.GC11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221803.21954.76453.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbbBWUSD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:18:03 -0500
Content-Disposition: inline
In-Reply-To: <20150221221803.21954.76453.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

On Sat, Feb 21, 2015 at 04:18:03PM -0600, Don Brace wrote:
> +/* extract sense key, asc, and ascq from sense data.  -1 means invalid. */
> +static void decode_sense_data(const u8 *sense_data, int sense_data_len,
> +			int *sense_key, int *asc, int *ascq)
> +{

Can't you just use scsi_normalize_sense()?
