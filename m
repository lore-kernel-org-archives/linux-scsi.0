From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [LSF/MM TOPIC NOTES] x86 ZONE_DMA love
Date: Sat, 28 Apr 2018 01:33:03 -0700
Message-ID: <20180428083303.GB31684@infradead.org>
References: <20180426215406.GB27853@wotan.suse.de>
 <20180427053556.GB11339@infradead.org>
 <20180427071843.GB17484@dhcp22.suse.cz>
 <alpine.DEB.2.20.1804271103160.11686@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1804271103160.11686@nuc-kabylake>
Sender: linux-kernel-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-mm@kvack.org, Jan Kara <jack@suse.cz>, matthew@wil.cx, x86@kernel.org, luto@amacapital.net, martin.petersen@oracle.com, jthumshirn@suse.de, broonie@kernel.org, linux-spi@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 27, 2018 at 11:07:07AM -0500, Christopher Lameter wrote:
> Well it looks like what we are using it for is to force allocation from
> low physical memory if we fail to obtain proper memory through a normal
> channel.  The use of ZONE_DMA is only there for emergency purposes.
> I think we could subsitute ZONE_DMA32 on x87 without a problem.
> 
> Which means that ZONE_DMA has no purpose anymore.
> 
> Can we make ZONE_DMA on x86 refer to the low 32 bit physical addresses
> instead and remove ZONE_DMA32?

While < 32-bit allocations are much more common there are plenty
of requirements for < 24-bit or other weird masks still.
