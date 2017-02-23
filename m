From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3 01/10] mpt3sas: switch to pci_alloc_irq_vectors
Date: Wed, 22 Feb 2017 19:52:55 -0500
Message-ID: <yq1o9xt7moo.fsf@oracle.com>
References: <1487680029-3701-1-git-send-email-hare@suse.de>
        <1487680029-3701-2-git-send-email-hare@suse.de>
        <20170222082841.GA22843@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39288 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932197AbdBWAxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Feb 2017 19:53:14 -0500
In-Reply-To: <20170222082841.GA22843@lst.de> (Christoph Hellwig's message of
        "Wed, 22 Feb 2017 09:28:41 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Martin, can we get at least this patch still in for 4.11?
Christoph> I'd really like to see as many intance of the old MSI-X
Christoph> allocation and IRQ affinity mess dead as soon as possible.

Me too. I'll queue it up for 4.11 unless Broadcom objects. And then
we'll do the rest for 4.12.

-- 
Martin K. Petersen	Oracle Linux Engineering
