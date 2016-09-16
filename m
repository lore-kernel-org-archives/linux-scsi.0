From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
Date: Fri, 16 Sep 2016 10:31:48 +0200
Message-ID: <20160916083148.GA2415@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de> <1473600688-24043-7-git-send-email-hch@lst.de> <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl>
Sender: kvm-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 16, 2016 at 10:01:42AM +0200, Hans Verkuil wrote:
> PCI_IRQ_MSI is unknown, I assume that this will appear in 4.9?

The flag is in 4.8-rc.
