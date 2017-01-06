From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] mpt3sas: switch to pci_alloc_irq_vectors
Date: Thu, 05 Jan 2017 20:43:50 -0500
Message-ID: <yq1wpe9hsix.fsf@oracle.com>
References: <1482240421-14847-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47117 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdAFBoI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2017 20:44:08 -0500
In-Reply-To: <1482240421-14847-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Tue, 20 Dec 2016 14:27:01 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Cleanup the MSI-X handling allowing us to use the PCI-layer
Hannes> provided vector allocation.

Sreekanth, Sathya: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
