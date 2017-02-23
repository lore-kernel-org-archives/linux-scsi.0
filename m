From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 01/12] mpt3sas: switch to pci_alloc_irq_vectors
Date: Thu, 23 Feb 2017 17:04:31 -0500
Message-ID: <yq1shn45ztc.fsf@oracle.com>
References: <1487759512-3873-1-git-send-email-hare@suse.de>
        <1487759512-3873-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41358 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbdBWWFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 17:05:20 -0500
In-Reply-To: <1487759512-3873-2-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Wed, 22 Feb 2017 11:31:41 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Cleanup the MSI-X handling allowing us to use the PCI-layer
Hannes> provided vector allocation.

Applied to 4.11/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
