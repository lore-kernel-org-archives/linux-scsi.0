From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] qlogic: don't use qinfo as name
Date: 21 Feb 2004 15:36:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077399404.2285.10.camel@mulgrave>
References: <20031020232200.GA473@cathedrallabs.org>
	<20040219150747.A23822@infradead.org>
	<20040219172619.GA667@cathedrallabs.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:32416 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261618AbUBUVgz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2004 16:36:55 -0500
In-Reply-To: <20040219172619.GA667@cathedrallabs.org>
List-Id: linux-scsi@vger.kernel.org
To: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-02-19 at 11:26, Aristeu Sergio Rozanski Filho wrote:
> yes, I'm sending it attached. I didn't changed them since, so I'm not sure if
> they will apply cleanly.

I'll put them in, but first I think the qlogicfas attachment type needs
to be all new style.

This:

> +#ifdef PCMCIA
> +	hreg = scsi_host_alloc(host, 0);
> +#else
>  	hreg = scsi_register(host, 0);	/* no host data */
> +#endif

Mixing of new and old styles is bound to cause difficulty.

James


