From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Tue, 7 Feb 2017 14:15:05 +0100
Message-ID: <20170207131505.GA19247@lst.de>
References: <1485854760-122683-1-git-send-email-hare@suse.de> <1485854760-122683-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40638 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754203AbdBGNX3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Feb 2017 08:23:29 -0500
Content-Disposition: inline
In-Reply-To: <1485854760-122683-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, mpt-fusionlinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.com>

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, I think the !smp_affinity_enable path should just go away
sooner or later.
