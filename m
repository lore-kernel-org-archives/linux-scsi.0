From: Mark Haverkamp <markh@osdl.org>
Subject: RE: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Wed, 15 Sep 2004 07:24:39 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095258279.29934.2.camel@markh1.pdx.osdl.net>
References: <60807403EABEB443939A5A7AA8A7458B1AAAB7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:7127 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S266173AbUIOOYx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 10:24:53 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B1AAAB7@otce2k01.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2004-09-15 at 04:47, Salyzyn, Mark wrote:
> Christoph Hellwig writes:
> 
> > > +	scsi_set_device(shost, &pdev->dev);
> > 
> > This one is bogus.  scsi_add_host already sets the device.
> 
> Which path sets the device? I got an intermittent panic as a result of
> the device not being set in my unit test (of the kernel of the day at
> the time of this modification, can't remember which version of the
> kernel ...). Which version of this kernel sets it?

In the latest version at least, line 111 in hosts.c sets
shost->shost_gendev.parent = dev ? dev : &platform_bus which is
essentially what scsi_set_device does.


-- 
Mark Haverkamp <markh@osdl.org>

