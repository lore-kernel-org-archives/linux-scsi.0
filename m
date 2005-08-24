From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [dm-devel] Re: [RFC PATCH 1/4] convert block layer drivers to
	blkerr error values
Date: Wed, 24 Aug 2005 16:02:07 -0500
Message-ID: <1124917327.5116.62.camel@mulgrave>
References: <1124874238.10888.18.camel@max>
	 <20050824192132.GA20663@us.ibm.com> <1124915637.5116.54.camel@mulgrave>
	 <430CDDA5.5000705@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:25553 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932214AbVHXVC3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 17:02:29 -0400
In-Reply-To: <430CDDA5.5000705@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: device-mapper development <dm-devel@redhat.com>, Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Wed, 2005-08-24 at 15:50 -0500, Mike Christie wrote:
> Would it be good then to also extend the fail fast flag to a bit map so 
> dm-multipath can tell scsi that scsi should handle device errors?

You mean have a REQ_FASTFAIL_{DEV,XPRT,DRV}?  The slight problem is that
we're already closing in on the limit for request flags (we're already
up to 26, this would take us to 28 with the maximum being 32) so I'll
defer to Jens on that.

James


