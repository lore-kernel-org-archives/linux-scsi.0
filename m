From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi_transport_spi.c
Date: Mon, 10 Jan 2005 23:23:31 +0000
Message-ID: <20050110232331.GA10138@infradead.org>
References: <91888D455306F94EBD4D168954A9457C2023B3@nacos172.co.lsil.com> <1105392133.3914.12.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:21384 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262745AbVAJXXq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:23:46 -0500
Content-Disposition: inline
In-Reply-To: <1105392133.3914.12.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: "Stephens, Larry" <larry.stephens@lsil.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

On Mon, Jan 10, 2005 at 10:22:13PM +0100, Arjan van de Ven wrote:
> > I've installed RHEL 4.  Where can I obtain the kernel source file for kernel
> > 2.6.9-1.906_ELsmp, containing scsi_transport_spi.c?
> 
> from kernel.org kernel linux-2.6.10.tar.bz ??
> or read the releasenotes for your beta to see how you get the source for
> the RHEL kernel.

http://people.redhat.com/davej/kernels/RHEL4/SRPMS.kernel/ has
kernel-2.6.9-5.EL.src.rpm which seems to be even more recent.

But you're probably better off working against a current mainline kernel
as a start.

