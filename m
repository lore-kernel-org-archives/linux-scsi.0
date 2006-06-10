From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Sat, 10 Jun 2006 12:50:18 -0400
Message-ID: <448AF84A.6050107@garzik.org>
References: <20060610160852.GA15316@havoc.gtf.org> <20060610161036.GA21454@infradead.org> <1149956952.3335.22.camel@mulgrave.il.steeleye.com> <20060610163420.GA23699@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49342 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751216AbWFJQuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 12:50:21 -0400
In-Reply-To: <20060610163420.GA23699@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@osdl.org, promise_linux@promise.com

Christoph Hellwig wrote:
> So removing the READ/WRITE6 emulation and setting the flag so the midlayer
> only uses READ/WRITE10+ is on top of the TODO list.  Right after that is

Done and checked into 'stex' branch at URL given.  I also removed 6-byte 
MODE SENSE.


> using the scsi_kmap_atomic_sg/scsi_kunmap_atomic_sg for the remaining
> emulated commands.  More comments later.

These functions don't appear to be in upstream yet.

	Jeff


