From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Proposal for new generic device API: dma_get_required_mask()
Date: 19 Jun 2004 10:00:50 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1087657251.2162.49.camel@mulgrave>
References: <1087481331.2210.27.camel@mulgrave>
	<m33c4tsnex.fsf@defiant.pm.waw.pl> <1087523134.2210.97.camel@mulgrave>
	<m3fz8s79dz.fsf@defiant.pm.waw.pl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org-S263979AbUFSPBC@vger.kernel.org>
In-Reply-To: <m3fz8s79dz.fsf@defiant.pm.waw.pl>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2004-06-18 at 18:07, Krzysztof Halasa wrote:
> James Bottomley <James.Bottomley@steeleye.com> writes:
> I don't think so. We already have separate masks for coherent
> and non-coherent mappings (in PCI API, and I'm told it's to be extended
> to DMA API as well). And we need them.
> 
> The problem is we're missing DMA masks for non-alloc calls (depending
> on the platform) and thus that it isn't very reliable. Drivers which
> need this are forced to bounce buffers themselves, and many of them
> will not work on 64-bit platforms (as of ~ 2.6.0, I don't check that
> regularly). And yes, we really need reliable masks for non-alloc
> mappings.

Could you elaborate on this?  In the current scheme the coherent mask is
for descriptor allocation (i.e. dma_alloc_coherent()) and the dma_mask
represents the bus physical addresses to which the device can DMA
directly; there's not much more the DMA API really does, what do you
think is missing?

James
