From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/6] hpsa: consolidate status variables
Date: Wed, 9 Aug 2017 15:40:30 +0200
Message-ID: <20170809134030.GA25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53526 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752341AbdHINkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:40:31 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

These seem to be modified from sysfs files, so you'll run into
read-modify-write atomicy issues with bitfields.

That being said while plain ints are somewhat safe the right thing
would be to use proper atomic bitops.
