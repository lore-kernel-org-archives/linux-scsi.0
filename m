From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 09/13] scsi: in scsi_prep_fn(), remove bogus comments & clean up
Date: Thu, 31 Mar 2005 11:22:17 +0100
Message-ID: <20050331102217.GE13842@infradead.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.B562915C@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:18403 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261200AbVCaKWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 05:22:21 -0500
Content-Disposition: inline
In-Reply-To: <20050331090647.B562915C@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

> -		/* 
> -		 * This sets up the scatter-gather table (allocating if
> -		 * required).
> -		 */
> +		/* This sets up the scatter-gather table (allocating if
> +		 * required). */

the old comment style is the preferred in linux, please leave it as-is
(here and in other places)

