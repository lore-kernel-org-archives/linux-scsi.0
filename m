From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/6] ipr: use pci_irq_allocate_vectors
Date: Mon, 19 Sep 2016 16:44:40 -0400
Message-ID: <yq1wpi78vrb.fsf@sermon.lab.mkp.net>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
        <1473600688-24043-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45479 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbcISUq3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 16:46:29 -0400
In-Reply-To: <1473600688-24043-3-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 11 Sep 2016 15:31:24 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Switch the ipr driver to use pci_alloc_irq_vectors.  We need
Christoph> to two calls to pci_alloc_irq_vectors as ipr only supports
Christoph> multiple MSI-X vectors, but not multiple MSI vectors.

Christoph> Otherwise this cleans up a lot of cruft and allows to use a
Christoph> common request_irq loop for irq types, which happens to only
Christoph> iterate over a single line in the non MSI-X case.

Brian, Gabriel: Please test and review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
