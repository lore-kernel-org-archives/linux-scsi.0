From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: remove superflous global host list
Date: Wed, 29 Sep 2004 23:34:09 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409292333070.4450@poirot.grange>
References: <20040929131302.GA27928@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:2482 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S269142AbUI2WKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 18:10:21 -0400
In-Reply-To: <20040929131302.GA27928@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Wed, 29 Sep 2004, Christoph Hellwig wrote:

> It's only used to "verify" the host pointer in the interrupt handler,
> which better had to be correct or else 90% of the drivers would break.

Thanks! Looks good to me.

Guennadi
---
Guennadi Liakhovetski

