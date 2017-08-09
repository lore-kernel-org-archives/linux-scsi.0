From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] hpsa: add support for legacy boards
Date: Wed, 9 Aug 2017 15:41:12 +0200
Message-ID: <20170809134112.GB25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53537 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdHINlN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:41:13 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Tue, Aug 08, 2017 at 10:35:11AM +0200, Hannes Reinecke wrote:
> Add support for legacy boards, ensuring to enable the driver for
> those boards only when 'hpsa_allow_any' is set.

Why the wildcard instead of the specific IDs from the cciss driver?
