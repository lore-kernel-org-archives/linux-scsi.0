From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] tmscsim: back out bogus eeprom reading changes
Date: Tue, 28 Sep 2004 22:46:45 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928204645.GA14611@lst.de>
References: <20040928142251.GA9334@lst.de> <Pine.LNX.4.60.0409282238360.5150@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:62143 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267785AbUI1Uqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 16:46:48 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409282238360.5150@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Tue, Sep 28, 2004 at 10:43:09PM +0200, Guennadi Liakhovetski wrote:
> On Tue, 28 Sep 2004, Christoph Hellwig wrote:
> 
> >
> >--- 1.52/drivers/scsi/tmscsim.c	2004-08-18 00:51:27 +02:00
> >+++ edited/drivers/scsi/tmscsim.c	2004-09-26 19:09:46 +02:00
> 
> Thanks, Christoph
> 
> James, please, apply.
> 
> One nitpick though: looks like the inlined dc390_check_for_safe_settings() 
> in dc390_module_init(), which you put there with your previous patch is 
> not needed now that the 2 out of line calls are back in place in 
> probe_one(), right, Christoph? If you agree, I'll remove the inlined 
> version for now - until we fix your EEPROM rework. I think, it is better 
> to do it in a separate patch.

fine with me, and a separate patch sounds good to me.

