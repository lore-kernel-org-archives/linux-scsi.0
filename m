From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: back out bogus eeprom reading changes
Date: Tue, 28 Sep 2004 22:43:09 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409282238360.5150@poirot.grange>
References: <20040928142251.GA9334@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:49891 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267893AbUI1Uo0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 16:44:26 -0400
In-Reply-To: <20040928142251.GA9334@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, 28 Sep 2004, Christoph Hellwig wrote:

>
> --- 1.52/drivers/scsi/tmscsim.c	2004-08-18 00:51:27 +02:00
> +++ edited/drivers/scsi/tmscsim.c	2004-09-26 19:09:46 +02:00

Thanks, Christoph

James, please, apply.

One nitpick though: looks like the inlined dc390_check_for_safe_settings() 
in dc390_module_init(), which you put there with your previous patch is 
not needed now that the 2 out of line calls are back in place in 
probe_one(), right, Christoph? If you agree, I'll remove the inlined 
version for now - until we fix your EEPROM rework. I think, it is better 
to do it in a separate patch.

Thanks
Guennadi
---
Guennadi Liakhovetski

