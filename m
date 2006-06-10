From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 18:10:38 +0100
Message-ID: <20060610171038.GA26821@infradead.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610161036.GA21454@infradead.org> <1149956952.3335.22.camel@mulgrave.il.steeleye.com> <20060610163420.GA23699@infradead.org> <448AF84A.6050107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44484 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751230AbWFJRKl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 13:10:41 -0400
Content-Disposition: inline
In-Reply-To: <448AF84A.6050107@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

On Sat, Jun 10, 2006 at 12:50:18PM -0400, Jeff Garzik wrote:
> >using the scsi_kmap_atomic_sg/scsi_kunmap_atomic_sg for the remaining
> >emulated commands.  More comments later.
> 
> These functions don't appear to be in upstream yet.

It's in scsi-misc, against which new scsi drivers should be submitted.
It's fine if you delay that conversion and non-sg path removal until you
send it to James for scsi-misc.

