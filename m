From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/14] block: Deprecate integrity tagging functions
Date: Wed, 11 Jun 2014 09:33:38 -0700
Message-ID: <20140611163338.GC28815@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-4-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53477 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbaFKQdk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:33:40 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-4-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:37PM -0400, Martin K. Petersen wrote:
> None of the filesystems appear interested in using the integrity tagging
> feature. Potentially because very few storage devices actually permit
> using the application tag space.
> 
> Deprecate the tagging functions.

This patch doesn't just deprecate them but outright removes them.

I'm fine with that, but the patch description needs an update.

