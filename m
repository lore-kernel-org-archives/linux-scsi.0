From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V10 1/4] dma-mapping: Rework dma_get_cache_alignment()
Date: Mon, 20 Nov 2017 09:34:59 +0100
Message-ID: <20171120083459.GA28235@lst.de>
References: <1510892872-32696-1-git-send-email-chenhc@lemote.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1510892872-32696-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Huacai Chen <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tariqt@mellanox.com>, Andy Gross <agross@codeaurora.org>, Robert Baldyga <r.baldyga@hackerion.com>
List-Id: linux-scsi@vger.kernel.org

Please send the scsi fixes on their own for now so that the rework
can go into 4.16.  If you don't want to do it I'll do it myself
and will send them to Martin for now you can the rebase the dma-mapping
and mips work after that.
