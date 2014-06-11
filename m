From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 09/14] block: Relocate integrity flags
Date: Wed, 11 Jun 2014 09:51:47 -0700
Message-ID: <20140611165147.GD9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-10-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbaFKQvu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:51:50 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-10-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:43PM -0400, Martin K. Petersen wrote:
> Move flags affecting the integrity code out of the bio bi_flags and into
> the block integrity payload.

It seems like bip is guaranteed to be non-NULL in all callers of the
getters and setters.  I'd recommend just dropping them and opencode
the flags manipulation.

