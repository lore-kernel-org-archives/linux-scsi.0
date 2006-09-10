From: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.18-rc5-mm1 + all hotfixes + nodemgr patches -- INFO: trying to register non-static key (the code is fine but needs lockdep annotation).
Date: Sun, 10 Sep 2006 13:58:24 +0200
Message-ID: <20060910115824.GB15356@elte.hu>
References: <a44ae5cd0609072006p627fb127g62949c62a5bfc6c2@mail.gmail.com> <tkrat.ae0a49a0374e41e2@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:215 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1750899AbWIJMGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Sep 2006 08:06:38 -0400
Content-Disposition: inline
In-Reply-To: <tkrat.ae0a49a0374e41e2@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Arjan van de Ven <arjan@infradead.org>, linux-scsi@vger.kernel.org


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> > INFO: trying to register non-static key.
> > the code is fine but needs lockdep annotation.
> > turning off the locking correctness validator.

> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Subject: SCSI: lockdep annotation in scsi_send_eh_cmnd
> 
> Fixup for lockdep enabled kernels: Annotate an on-stack completion.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

thanks.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
