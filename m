From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Wed, 25 May 2011 04:04:09 -0400
Message-ID: <20110525080409.GA16582@infradead.org>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, May 24, 2011 at 04:53:50PM -0700, David Rientjes wrote:
> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, which is
> not possible if CONFIG_ZONE_DMA is disasbled.  Avoid compiling it without
> DMA support.

And you're sure it actually needs it and isn't some sort of typo?  It
might help to Cc the maintainer to figure that out.
