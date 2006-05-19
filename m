From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] ppa: no highmem pages
Date: Fri, 19 May 2006 11:15:27 -0500
Message-ID: <1148055327.3410.43.camel@mulgrave.il.steeleye.com>
References: <20060518220744.cb986f3f.rdunlap@xenotime.net>
	 <1148050838.3410.32.camel@mulgrave.il.steeleye.com>
	 <20060519090813.0c1f7c83.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:42912 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932439AbWESQPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 May 2006 12:15:30 -0400
In-Reply-To: <20060519090813.0c1f7c83.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org

On Fri, 2006-05-19 at 09:08 -0700, Randy.Dunlap wrote:
> +	.unchecked_isa_dma	= 1, /* ppa cannot deal with highmem, so
> +				      * this is an easy trick to ensure
> +				      * all io pages for this host reside
> +				      * in low memory */

You still don't need this piece, do you?  It will cause all the kmallocs
still to be GFP_DMA ... allocations from zone normal should be fine,
shouldn't they?

James


