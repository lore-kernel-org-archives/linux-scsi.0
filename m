From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 5/6] hpsa: do not print errors for unsupported report
        luns format
Date: Wed, 9 Aug 2017 15:46:16 +0200
Message-ID: <20170809134616.GF25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53584 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752459AbdHINqS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:46:18 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

I don't like the misnamed supported flag.  Either we should always ignore
the errors, or key it off a specific flag for newer firmware.
