From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/14] block: Integrity checksum flag
Date: Wed, 11 Jun 2014 09:52:28 -0700
Message-ID: <20140611165228.GE9511@infradead.org>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
 <1401334128-15499-11-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaFKQw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 12:52:29 -0400
Content-Disposition: inline
In-Reply-To: <1401334128-15499-11-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

On Wed, May 28, 2014 at 11:28:44PM -0400, Martin K. Petersen wrote:
> Make the choice of checksum a per-I/O property by introducing a flag
> that can be inspected by the SCSI layer.

Why?

