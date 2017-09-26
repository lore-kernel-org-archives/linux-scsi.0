From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V7 1/2] dma-mapping: Rework dma_get_cache_alignment()
Date: Tue, 26 Sep 2017 08:10:19 +0200
Message-ID: <20170926061019.GA6416@lst.de>
References: <1506332766-23966-1-git-send-email-chenhc@lemote.com> <20170925125107.GC8130@lst.de> <tencent_7716E99906A9D63D4592EFB6@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_7716E99906A9D63D4592EFB6@qq.com>
Sender: stable-owner@vger.kernel.org
To: =?utf-8?B?6ZmI5Y2O5omN?= <chenhc@lemote.com>
Cc: Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Fuxin Zhang <zhangfx@lemote.com>, linux-kernel <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <james.hogan@imgtec.com>, linux-mips <linux-mips@linux-mips.org>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <rolandd@cisco.com>, Pawel Osciak <pawel@osciak.com>, Kyungmin Park <kyungmin.park@samsung.com>, Michael Chan <michael.chan@broadcom.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ivan Mikhaylov <ivan@ru.ibm.com>, Tariq Toukan <tari>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 26, 2017 at 09:48:01AM +0800, 陈华才 wrote:
> Hi, Christoph,
> 
> Can I put the declaration in asm/dma-coherence.h?

Generally something not expose to the rest of the kernel (that is not
in arch/mips/include/) would be preferred, but in the end the architecture
maintainer will have to decide.

> And, last time you said it is OK to pass a NULL to dma_get_cache_alignment() and cc all driver maintainers. I have do so.

No, I asked you to converted everything to pass the struct device and
cc the driver maintainers.
