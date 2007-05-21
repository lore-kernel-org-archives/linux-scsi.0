From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] jazz_esp converted to use esp_core
Date: Mon, 21 May 2007 19:14:50 -0400
Message-ID: <465227EA.2060507@garzik.org>
References: <20070521210224.GA24573@alpha.franken.de> <20070521230041.GA12090@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:46208 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757690AbXEUXOz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 19:14:55 -0400
In-Reply-To: <20070521230041.GA12090@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, davem@davemloft.net

Christoph Hellwig wrote:
> Note to Dave:  it probably would be nice to just build esp_scsi.o
> from the makefile like the old NCR53C9x drivers did instead of the
> Kconfig hackery, what do you think?


If the dependent drivers reside in the same directory, Makefile hackery 
is definitely preferred.

That's what libata did until things got complicated, and it worked well.

	Jeff


