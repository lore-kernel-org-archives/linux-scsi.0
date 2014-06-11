From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 08/14] block: Add a disk flag to block integrity profile
Date: Wed, 11 Jun 2014 09:48:58 -0700
Message-ID: <20140611164858.GC9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161AbaFKQtA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:49:00 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-9-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:42PM -0400, Martin K. Petersen wrote:
> So far we have relied on the app tag size to determine whether a disk
> has been formatted with T10 protection information or not. However, not
> all target devices provide application tag storage.
> 
> Add a flag to the block integrity profile that indicates whether the
> disk has been formatted with protection information.

I'm totally confused on why the sysfs file and flag are named 'disk'.
What does it stand for given that we already have a very established
use of the term 'disk' in block I/O land..

