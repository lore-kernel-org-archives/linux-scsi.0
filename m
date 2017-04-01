From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
Date: Sat, 1 Apr 2017 16:16:35 -0600
Message-ID: <c5d7da85-41fd-2769-fcf8-b3c2a1fab95f@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
 <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
 <c8edc480-a2ac-a763-8438-18f3396db483@deltatee.com>
 <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <e2165253dc355d5cb223e754d78047b1@codeaurora.org>
Sender: linux-pci-owner@vger.kernel.org
To: okaya@codeaurora.org
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey,

On 31/03/17 08:17 PM, okaya@codeaurora.org wrote:
> See drivers/pci and drivers/acpi directory.

The best I could find was the date of the firmware/bios. I really don't
think that makes sense to tie the two together. And really the more that
I think about it trying to do a date cutoff for this seems crazy without
very comprehensive hardware testing done. I have no idea which AMD chips
have decent root ports for this and then if we include all of ARM and
POWERPC, etc there's a huge amount of unknown hardware. Saying that the
system's firmware has to be written after 2016 seems like an arbitrary
restriction that isn't likely to correlate to any working systems.

I still say the only sane thing to do is allow all switches and then add
a whitelist of root ports that are known to work well. If we care about
preventing broken systems in a comprehensive way then that's the only
thing that is going to work.

Logan
