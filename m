From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/6] arcmsr: use pci_alloc_irq_vectors
Date: Mon, 19 Sep 2016 16:45:42 -0400
Message-ID: <yq1shsv8vpl.fsf@sermon.lab.mkp.net>
References: <1473600688-24043-1-git-send-email-hch@lst.de>
        <1473600688-24043-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473600688-24043-2-git-send-email-hch@lst.de> (Christoph
        Hellwig's message of "Sun, 11 Sep 2016 15:31:23 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> Switch the arcmsr driver to use pci_alloc_irq_vectors.  We
Christoph> need to two calls to pci_alloc_irq_vectors as arcmsr only
Christoph> supports multiple MSI-X vectors, but not multiple MSI
Christoph> vectors.

Christoph> Otherwise this cleans up a lot of cruft and allows to use a
Christoph> common request_irq loop for irq types, which happens to only
Christoph> iterate over a single line in the non MSI-X case.

Ching: Please test and review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
