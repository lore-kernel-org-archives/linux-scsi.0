From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Wed, 07 Dec 2016 18:54:14 -0500
Message-ID: <yq137hzs3bt.fsf@sermon.lab.mkp.net>
References: <1480679543-79236-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34809 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932434AbcLGXyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2016 18:54:31 -0500
In-Reply-To: <1480679543-79236-1-git-send-email-hare@suse.de> (Hannes
        Reinecke's message of "Fri, 2 Dec 2016 12:52:23 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sumit Saxena <sumit.saxena@broadcom.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Applied to 4.10/scsi-queue.

Sumit, please rebase your patch series on top of this.

-- 
Martin K. Petersen	Oracle Linux Engineering
