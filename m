From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Thu, 16 Sep 2004 12:29:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040916122925.A32569@infradead.org>
References: <60807403EABEB443939A5A7AA8A7458B1AAAB7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:53260 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267957AbUIPL3e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2004 07:29:34 -0400
Content-Disposition: inline
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B1AAAB7@otce2k01.adaptec.com>; from mark_salyzyn@adaptec.com on Wed, Sep 15, 2004 at 07:47:45AM -0400
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Sep 15, 2004 at 07:47:45AM -0400, Salyzyn, Mark wrote:
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

Since mid-2.5.x.  Maybe you try to access it before scsi_add_host is called?
