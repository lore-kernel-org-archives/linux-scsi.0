From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/6] hpsa: disable volume status check for older
        controller
Date: Wed, 9 Aug 2017 15:42:30 +0200
Message-ID: <20170809134230.GC25852@lst.de>
References: <1502181315-102499-1-git-send-email-hare@suse.de> <1502181315-102499-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53548 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752409AbdHINmb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Aug 2017 09:42:31 -0400
Content-Disposition: inline
In-Reply-To: <1502181315-102499-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Why that weird supported flag check?

(which also means I need to got back to the previous patch and understand
that part..)
