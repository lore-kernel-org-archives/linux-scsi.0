From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Wed, 22 Feb 2017 09:28:41 +0100
Message-ID: <20170222082841.GA22843@lst.de>
References: <1487680029-3701-1-git-send-email-hare@suse.de> <1487680029-3701-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41656 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754499AbdBVI2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 03:28:45 -0500
Content-Disposition: inline
In-Reply-To: <1487680029-3701-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

Martin,

can we get at least this patch still in for 4.11?  I'd really like
to see as many intance of the old MSI-X allocation and IRQ affinity
mess dead as soon as possible.
