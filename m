From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/14] block: Deprecate the use of the term sector in the
 context of block integrity
Date: Wed, 11 Jun 2014 09:45:38 -0700
Message-ID: <20140611164538.GA9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-6-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54257 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaFKQpo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:45:44 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-6-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:39PM -0400, Martin K. Petersen wrote:
> The protection interval is not necessarily tied to the logical block
> size of a block device. Stop using the terms sector and sectors.

This does more than just renaming symbols, so it needs a better
description or even better splitting into separate patches.

