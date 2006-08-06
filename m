From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] hptiop: backout ioctl mess
Date: Sun, 06 Aug 2006 13:18:52 -0500
Message-ID: <1154888332.3683.231.camel@mulgrave.il.steeleye.com>
References: <20060730171336.GA31646@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32972 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751669AbWHFSTO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Aug 2006 14:19:14 -0400
In-Reply-To: <20060730171336.GA31646@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@SteelEye.com, linux@highpoint-tech.com, linux-scsi@vger.kernel.org

On Sun, 2006-07-30 at 19:13 +0200, Christoph Hellwig wrote:
> The hptiop just got merged with a horrible amount of really bad ioctl
> code that is against the standards for new scsi drivers.  This patch
> backs it out (and fixes a small bug where scsi_add_host is called to
> early).  We can re-add proper APIs once we agree on them.

I'm assuming the model you want to use is megaraid_sas, which only has a
couple of defined ioctls?

> Please send this to Linus for 2.6.19 so that the ioctls don't make it
> into a release.

OK, provided you take the lead in sorting out the ioctl infrastructure
for this driver ...

James


