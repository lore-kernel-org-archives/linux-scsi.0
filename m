From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Block/SCSI data integrity update v3
Date: Sun, 7 Sep 2014 09:29:57 -0700
Message-ID: <20140907162957.GA17353@infradead.org>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
 <53FF8CC9.9030206@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56186 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaIGQ37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Sep 2014 12:29:59 -0400
Content-Disposition: inline
In-Reply-To: <53FF8CC9.9030206@fb.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, hch@lst.de, sagig@mellanox.com

On Thu, Aug 28, 2014 at 02:10:49PM -0600, Jens Axboe wrote:
> On 08/28/2014 01:31 PM, Martin K. Petersen wrote:
> > This is the data integrity patch series originally submitted for 3.16
> > and 3.17.  It has been rebased on top of block/for-3.18/core.  Other
> > than that there are no changes from v2.
> 
> Thanks, picked up. I did not apply 14/14 since that should go through
> the SCSI tree. I can carry it if need be, but it'd be nice to have a
> SCSI signoff on it then.

While Sagi found some minor nitpicks I think we could address them later
if needed, so

Acked-by: Christoph Hellwig <hch@lst.de>

from me for picking it up through the block tree.
