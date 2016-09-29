From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 2/6] ipr: use pci_irq_allocate_vectors
Date: Thu, 29 Sep 2016 17:32:37 +0200
Message-ID: <20160929153237.GA32512@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de> <1473600688-24043-3-git-send-email-hch@lst.de> <200e5b3f-8555-9cd3-7940-0ec0f2867b95@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pci-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200e5b3f-8555-9cd3-7940-0ec0f2867b95@linux.vnet.ibm.com>
Sender: linux-pci-owner@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2016 at 09:01:44AM -0500, Brian King wrote:
> Thanks Christoph. Very nice. As I was reviewing the patch, I noticed
> the additional PCI_IRQ_AFFINITY flag, which is currently not being set
> in this patch. Is the intention to set that globally by default, or
> should I follow up with a one liner to add that to the ipr driver
> in the next patch set I send out?

Hi Brian,

PCI_IRQ_AFFINITY seems useful for ipr, especially if you also increase
the number of vectors above the current default 2.  And yes, please
make it a separate patch.
