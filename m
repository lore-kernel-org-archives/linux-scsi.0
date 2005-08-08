From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] Bug 4940 Repeatable Kernel Panic on Adaptec 2015S I20 device on bootup
Date: Mon, 8 Aug 2005 11:47:23 -0400
Message-ID: <20050808154723.GB25357@devserv.devel.redhat.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01684222@otce2k03.adaptec.com> <20050808141618.GA24682@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:29933 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932088AbVHHPro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 11:47:44 -0400
Content-Disposition: inline
In-Reply-To: <20050808141618.GA24682@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Markus.Lidel@shadowconnect.com, Andrew Morton <akpm@osdl.org>, alan@redhat.com

On Mon, Aug 08, 2005 at 03:16:18PM +0100, Christoph Hellwig wrote:
> Please either update the driver to use the pci_driver model or even
> better remove it completely and let everyone use the i2o drivers now
> that they have full 64bit dma and managment support.

In the mean time. I ack the fix for what we have now. I don't see the point
of fixing dpt_i2o much further given in another 6 months your wish can probably
come true.

Alan

