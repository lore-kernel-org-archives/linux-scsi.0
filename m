From: Christoph Hellwig <hch@lst.de>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 16:15:07 +0100
Message-ID: <20041117151507.GA27190@lst.de>
References: <20041117145444.GA26717@lst.de> <OF612A97F2.2AB23760-ON42256F4F.00531770-42256F4F.0053544D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:747 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262341AbUKQPPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 10:15:12 -0500
Content-Disposition: inline
In-Reply-To: <OF612A97F2.2AB23760-ON42256F4F.00531770-42256F4F.0053544D@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@osdl.org>, BOEBLINGEN LINUX390 <linux390@de.ibm.com>, linux-scsi@vger.kernel.org

> > changes to scsi LLDDs should always go via linux-scsi.
> 
> Fine, that answers half of the question. The other half of the question is about
> the sign-off chain. So far I've been sending the zfcp updates directly to Andrew
> for integration. Wouldn't it make more sense to have a scsi guy in the loop
> before the patch reaches Andrew?

You shouldn't send them to Andrew at all.  Send them to James, and he'll
put it into the scsi tree which is picked up in -mm.

