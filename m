From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [Emulex] Ready for next round...
Date: Fri, 9 Jul 2004 23:10:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040709221032.GA7005@infradead.org>
References: <3356669BBE90C448AD4645C843E2BF28034F9630@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:2994 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265985AbUGIWKc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 18:10:32 -0400
Content-Disposition: inline
In-Reply-To: <3356669BBE90C448AD4645C843E2BF28034F9630@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.Com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, Linux SCSI Reflector <linux-scsi@vger.kernel.org>

> - [PATCH] remove dead event counters from lpfc. Rather than remove this
> code, as it will be used later, we have at least consolidated it and made
> the events visible via sysfs.

Still a bad idea to keep dead code around.  Propose the chances if you have
a sysfs implementation, I'm pretty sure it will need major rework.

Btw, if someone sends you patches it would be nice to get timely applied/not
applied/needs works/please changes this and that feedback after you looked
at the patch.

