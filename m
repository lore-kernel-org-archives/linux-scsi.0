From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/6] media/cobalt: use pci_irq_allocate_vectors
Date: Wed, 14 Dec 2016 11:47:31 +0100
Message-ID: <20161214104731.GA30382@lst.de>
References: <1473600688-24043-1-git-send-email-hch@lst.de> <1473600688-24043-7-git-send-email-hch@lst.de> <1c24ae65-067f-52fc-edfa-af2d0e222a19@xs4all.nl> <20161214102913.GA30236@lst.de> <c5453c65-1256-338f-0ff1-6499d11987af@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c5453c65-1256-338f-0ff1-6499d11987af@xs4all.nl>
Sender: linux-block-owner@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Christoph Hellwig <hch@lst.de>, hans.verkuil@cisco.com, brking@us.ibm.com, haver@linux.vnet.ibm.com, ching2048@areca.com.tw, axboe@fb.com, alex.williamson@redhat.com, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2016 at 11:37:17AM +0100, Hans Verkuil wrote:
> Completely forgot this. Is it OK to queue it for 4.11? Or is it blocking
> other follow-up work you want to do for 4.10?

My plan was to see if Bjorn would take the patch to do the trivial removal
of pci_enable_msix_exact and pci_enable_msix_range even as a late 4.10 patch
given it's so harmless, but either way there is follow work pending ASAP
so getting it in for 4.10 would be very helpful.
