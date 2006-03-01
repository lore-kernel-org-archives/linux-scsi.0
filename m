From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 01 Mar 2006 09:39:01 -0600
Message-ID: <1141227541.3276.26.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
	 <20060301152929.GZ4816@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:27273 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932072AbWCAPjX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 10:39:23 -0500
In-Reply-To: <20060301152929.GZ4816@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Kai Makisara <Kai.Makisara@kolumbus.fi>, matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, 2006-03-01 at 16:29 +0100, Jens Axboe wrote:
> Strictly speaking, the clustering bit is unrelated. I seem to recall
> Gerard years ago talking about some sym chips that did not like
> clustering, hence it was disabled.

Yes, I remember that too ... I've never been able to find out which
chip, though ... the scripts all seem happily coded for variable size sg
segments.

However, given the new way 2.6 does memory allocations,
ENABLE_CLUSTERING will probably make quite a difference to the size of
the sg list ... since we try to allocate contiguous pages, physical
merging becomes much more of a possibility (I think I last measured it
at around 30% of all SG tables, as opposed to <1% with the old
allocation method).

James


