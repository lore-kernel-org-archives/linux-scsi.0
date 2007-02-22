From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 16:06:41 -0600
Message-ID: <1172182001.3378.38.camel@mulgrave.il.steeleye.com>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net>
	 <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
	 <20070222165123.GC2672@beardog.cca.cpqcorp.net>
	 <20070222132434.d84d3248.akpm@linux-foundation.org>
	 <1172180484.3378.34.camel@mulgrave.il.steeleye.com>
	 <20070222220225.GC14162@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45519 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbXBVWHz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Feb 2007 17:07:55 -0500
In-Reply-To: <20070222220225.GC14162@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com

On Thu, 2007-02-22 at 16:02 -0600, Mike Miller (OS Dev) wrote:
> Will this patch for my patch work for now?

Yes, I think that should be fine ... it's only a theoretical worry; at
the moment sector_t is unsigned ... but just in case.

James


