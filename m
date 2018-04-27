From: Christopher Lameter <cl@linux.com>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Fri, 27 Apr 2018 11:36:23 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804271136030.11686@nuc-kabylake>
References: <20180426215406.GB27853@wotan.suse.de> <20180427053556.GB11339@infradead.org> <20180427071843.GB17484@dhcp22.suse.cz> <alpine.DEB.2.20.1804271103160.11686@nuc-kabylake> <20180427161813.GD8161@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180427161813.GD8161@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, linux-spi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 27 Apr 2018, Matthew Wilcox wrote:

> Some devices have incredibly bogus hardware like 28 bit addressing
> or 39 bit addressing.  We don't have a good way to allocate memory by
> physical address other than than saying "GFP_DMA for anything less than
> 32, GFP_DMA32 (or GFP_KERNEL on 32-bit) for anything less than 64 bit".
>
> Even CMA doesn't have a "cma_alloc_phys()".  Maybe that's the right place
> to put such an allocation API.

The other way out of this would be to require a IOMMU?
