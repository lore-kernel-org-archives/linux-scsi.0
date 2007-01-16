From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: ipr SATA problems in 2.6.20
Date: Tue, 16 Jan 2007 23:28:07 +0000
Message-ID: <20070116232807.79fa52d3@localhost.localdomain>
References: <45AD50AD.2040700@linux.vnet.ibm.com>
	<20070116224115.50d29cf7@localhost.localdomain>
	<45AD55A4.50208@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45AD55A4.50208@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 16 Jan 2007 17:45:56 -0500
Jeff Garzik <jgarzik@pobox.com> wrote:

> Alan wrote:
> >> The other oddity I've been seeing is that I am getting zero length commands,
> >> such as TEST_UNIT_READY with a dma_dir of DMA_FROM_DEVICE. Shouldn't this be
> >> DMA_NONE? I'm still tracking this down.
> > 
> > I was looking at a PATA trace that was looking the same 2 days ago and
> > couldn't figure what was going on. 
> 
> Tejun recently updated the CDB length areas of the code.  I bet it's 
> either a bug somewhere in there, or the SCSI layer isn't passing us 
> proper command lengths in a case or two.

That might explain a few things - the qemu PIIX3 emulation bug possibly
and also perhaps the recent NVidia iommu fun.

Alan
