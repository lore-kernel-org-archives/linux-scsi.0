From: "Alexandru N. Barloiu" <slak@dale.ro>
Subject: [Fwd: Re: dpt_i2o in 2.6.0_test*]
Date: 10 Aug 2003 17:32:44 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1060525964.3879.147.camel@hammer.dale.ro>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from light.kappa.ro ([194.102.254.118]:26813 "EHLO mx.dale.ro")
	by vger.kernel.org with ESMTP id S269559AbTHJOdp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2003 10:33:45 -0400
Received: from astro.dale.ro (localhost [127.0.0.1])
	by mx.dale.ro (Postfix) with SMTP id 6A00C4052D10
	for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2003 17:36:48 +0300 (EEST)
Received: from hammer.dale.ro (hammer.dale.ro [193.231.198.250])
	by mx.dale.ro (Postfix) with ESMTP id 94DAA40519B4
	for <linux-scsi@vger.kernel.org>; Sun, 10 Aug 2003 17:36:47 +0300 (EEST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----Forwarded Message-----
> From: Alexandru N. Barloiu <slak@dale.ro>
> To: Christoph Hellwig <hch@infradead.org>
> Subject: Re: dpt_i2o in 2.6.0_test*
> Date: 10 Aug 2003 17:25:12 +0300
> 
> On Sat, 2003-08-09 at 23:17, Christoph Hellwig wrote:
> > On Sat, Aug 09, 2003 at 11:12:40PM +0300, Alexandru N. Barloiu wrote:
> > > hello,
> > > I just wanted to ask if there is a fix for this.
> > > 
> > >   CC      drivers/scsi/dpt_i2o.o
> > > drivers/scsi/dpt_i2o.c:32:2: #error Please convert me to
> > 
> > According to Alan the fix is to use the i2o_scsi driver instead.
> > Could you try it?
> 
> I did. This is the output. I can't figure out if the driver supports it
> or not. Should I pass something to the kernel in grub ? I will begin to
> read the i2o docs maybe I am missing something.
> 
> I2O Core - (C) Copyright 1999 Red Hat Software
> I2O: Event thread created as pid 15
> i2o: Checking for PCI I2O controllers...
> i2o: Skipping Adaptec/DPT I2O raid with preferred native driver.
> I2O configuration manager v 0.04.
>   (C) Copyright 1999 Red Hat Software
> I2O Block Storage OSM v0.9
>    (c) Copyright 1999-2001 Red Hat Software.
> i2o_block: Checking for Boot device...
> i2o_block: Checking for I2O Block devices...
> i2o_scsi.c: Version 0.1.2
>   chain_pool: 0 bytes @ dfd44340
>   (512 byte buffers X 4 can_queue X 0 i2o controllers)
> i2c /dev entries driver module version 2.7.0 (20021208)
> 
> 
> -- 
> Alexandru N. Barloiu <slak@dale.ro>
> Dale Media
-- 
Alexandru N. Barloiu <slak@dale.ro>
Dale Media

