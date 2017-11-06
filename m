From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V9 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Mon, 6 Nov 2017 19:18:30 +0100
Message-ID: <20171106181830.GA29402@lst.de>
References: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508742767-28366-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

Looks like there hasn't been much interest in reworking this to make
stable backporting easier.  I can apply patch 1 to the dma-mapping
tree if that's still the plan, but for the other patches I'd need
ACKs from the other maintainers.
