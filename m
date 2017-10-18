From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH V8 5/5] libata: Align DMA buffer to
 dma_get_cache_alignment()
Date: Wed, 18 Oct 2017 20:54:22 +0100
Message-ID: <20171018205422.7fc8cbce@alans-desktop>
References: <1508227542-13165-1-git-send-email-chenhc@lemote.com>
        <1508227542-13165-5-git-send-email-chenhc@lemote.com>
        <94f55c1e-7553-0fc8-124e-ac6df5ac10ce@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <94f55c1e-7553-0fc8-124e-ac6df5ac10ce@cogentembedded.com>
Sender: stable-owner@vger.kernel.org
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Huacai Chen <chenhc@lemote.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>     This function is called only for the PIO mode commands, so I doubt this is 
> necessary...

That is true but there are platforms out there that issue disk level PIO
commands via DMA (or can do so). Indeed the Cyrix MediaGX could do that
in the 1990s but I never add support 8)

So I think it makes sense to allocate the buffers DMA aligned, but it
doesn't seem to explain the situation in this case and I think it would
be helpful to know what platform and ATA driver is tripping this and wny
they are the only people in the universe to have the problem.

Alan
