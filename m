From: Christoph Hellwig <hch@lst.de>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 17:20:14 +0100
Message-ID: <20041117162014.GA28603@lst.de>
References: <OF185BBE71.A415A9D9-ONC1256F4F.0053BEA6-C1256F4F.00562DD6@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:17646 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262364AbUKQQUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 11:20:19 -0500
Content-Disposition: inline
In-Reply-To: <OF185BBE71.A415A9D9-ONC1256F4F.0053BEA6-C1256F4F.00562DD6@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke3 <MPESCHKE@de.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390 <linux390@de.ibm.com>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>

> And here you appear to say "by the way, we'll never do it anyway"
> (taking your previous comments on the API into account as well) -
> which to some degree contributes to the dilemma faced by lldd writers.
> 
> What is your answer to those who wish to manage FC HBAs in a
> common way?

Join Emulex in adding managment support to the fc transport class.

