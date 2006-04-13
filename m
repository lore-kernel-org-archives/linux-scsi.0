From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aha152x(_cs) oops
Date: Thu, 13 Apr 2006 12:40:36 -0500
Message-ID: <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:46241 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750886AbWDMRkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 13:40:43 -0400
In-Reply-To: <20060413093615.661b7018.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>

On Thu, 2006-04-13 at 09:36 -0700, Randy.Dunlap wrote:
> Is aha152x(_cs) known not to work with highmem or is it just busted
> in its use of s/g list handling?
> This is 2.6.17-rc1-git7 on a Dell notebook with 2 GB RAM.
> 
> On all recent kernels, I get an Oops in aha152x.c:datao_run(),
> where the SG_ADDRESS() macro uses page_address().

This routine is trying to do the identical action that Guennady
Liakhovetski just posted a dc395x patch for (i.e. re-feed a DMA
transaction via PIO) could we see if we can utilise pieces of that patch
to do this correctly (or provide more common infrastructure)?

James


