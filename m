From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Thu, 23 Dec 2004 13:03:41 -0600
Message-ID: <1103828621.5290.42.camel@mulgrave>
References: <20041221223645.GA2736@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:43406 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261188AbULWTEb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Dec 2004 14:04:31 -0500
In-Reply-To: <20041221223645.GA2736@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-12-21 at 16:36 -0600, Dave C Boutcher wrote:
> Description: Based on comments from Jens Axboe, remove
> redundant module parm to set max sectors.  This should
> be set through the /dev/block/xxx/queue/max_sectors_kb
> interface.  This incremental patch fixes the only comments
> received to the previous set of patches submitted.

This one doesn't apply to scsi-misc-2.6, could you reroll against what's
there?

Thanks,

James


