From: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 14:32:13 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <21728.1081859533@www46.gmx.net>
References: <200404131416.32700.info@roessner-net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:27604 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263280AbUDMMcQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 08:32:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christian Roessner <info@roessner-net.com>
Cc: linux-scsi@vger.kernel.org

> drivers/scsi/tmscsim.c: In function `dc390_initDCB':
> drivers/scsi/tmscsim.c:1770: error: syntax error before "id"

oh, sorry, forgot - there's a missing comma there. Should be:

DCBDEBUG(printk (KERN_INFO "DC390: alloc mem for DCB (ID %i, LUN %i): %p\n",
\

Please, fix, and try again.

Thanks
Guennadi

