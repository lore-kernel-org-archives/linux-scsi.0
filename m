From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 34/35] scsi: Move eh_device_reset_handler() to use
        scsi_device as argument
Date: Sat, 24 Jun 2017 09:07:50 +0200
Message-ID: <20170624070750.GA14437@lst.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de> <1498222975-71858-35-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56866 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbdFXHHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jun 2017 03:07:51 -0400
Content-Disposition: inline
In-Reply-To: <1498222975-71858-35-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Please factor out any non-trivial changes to separate patches.

E.g. the fnic tag reserved tag is something that should have patch
on it's own with a proper description (and I like that change a lot
btw!)
