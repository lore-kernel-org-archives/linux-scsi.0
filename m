From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Wed, 25 Jun 2014 03:24:41 -0700
Message-ID: <20140625102441.GA24735@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
 <20140611164858.GC9511@infradead.org>
 <yq1ha3qrk1x.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55388 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaFYKYs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 06:24:48 -0400
Content-Disposition: inline
In-Reply-To: <yq1ha3qrk1x.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, Jun 11, 2014 at 09:30:34PM -0400, Martin K. Petersen wrote:
> /sys/block/foo/integrity/disk_is_formatted_with_pi
> /sys/block/foo/integrity/disk_is_integrity_capable
> /sys/block/foo/integrity/disk_supports_storing_pi
> 
> Or would you prefer something other than disk? target? storage_device?

I'd defintively prefer the target_ prefix and one of the descriptive
suffixes.

