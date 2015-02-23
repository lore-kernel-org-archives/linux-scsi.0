From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/43] hpsa: do not ignore return value of
 hpsa_register_scsi
Date: Mon, 23 Feb 2015 12:18:35 -0800
Message-ID: <20150223201835.GD11037@infradead.org>
References: <20150221221553.21954.32599.stgit@brunhilda>
 <20150221221826.21954.84017.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34945 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbbBWUSg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Feb 2015 15:18:36 -0500
Content-Disposition: inline
In-Reply-To: <20150221221826.21954.84017.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com, linux-scsi@vger.kernel.org

On Sat, Feb 21, 2015 at 04:18:26PM -0600, Don Brace wrote:
> +	if (hpsa_register_scsi(h)) /* hook ourselves into SCSI subsystem */
> +		goto clean4;

Shouldn't we propagate the exact error code returned?
