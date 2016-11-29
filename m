From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] isci: switch to pci_alloc_irq_vectors
Date: Tue, 29 Nov 2016 11:40:29 -0500
Message-ID: <yq137iap7cy.fsf@sermon.lab.mkp.net>
References: <1479449432-7375-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18954 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755801AbcK2Qkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Nov 2016 11:40:39 -0500
In-Reply-To: <1479449432-7375-1-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Fri, 18 Nov 2016 07:10:32 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: artur.paszkiewicz@intel.com, Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, intel-linux-scu@intel.com, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Artur or Dan: Please review!

-- 
Martin K. Petersen	Oracle Linux Engineering
