From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: back out bogus eeprom reading changes
Date: Thu, 30 Sep 2004 23:32:40 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409302328530.3449@poirot.grange>
References: <20040928142251.GA9334@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:63162 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S269518AbUI3Vdb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 17:33:31 -0400
In-Reply-To: <20040928142251.GA9334@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

James, Christoph

On Tue, 28 Sep 2004, Christoph Hellwig wrote:

>
> --- 1.52/drivers/scsi/tmscsim.c	2004-08-18 00:51:27 +02:00
> +++ edited/drivers/scsi/tmscsim.c	2004-09-26 19:09:46 +02:00

Is there any chance to get this patch into 2.6.9? Linus' comment in his 
2.6.9-rc3 announcement "2.6.9 cycle is getting too long, but here's a 
-rc3 and hopefully we're getting there now." makes me wonder. This patch 
seems pretty important, at least for dc390 users.

Thanks
Guennadi
---
Guennadi Liakhovetski

