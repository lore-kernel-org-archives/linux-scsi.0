From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] 2.6.9 aacraid: aac_count fix
Date: Wed, 15 Sep 2004 07:47:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <60807403EABEB443939A5A7AA8A7458B1AAAB7@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:17106 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265887AbUIOLrs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 07:47:48 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>, Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig writes:

> > +	scsi_set_device(shost, &pdev->dev);
> 
> This one is bogus.  scsi_add_host already sets the device.

Which path sets the device? I got an intermittent panic as a result of
the device not being set in my unit test (of the kernel of the day at
the time of this modification, can't remember which version of the
kernel ...). Which version of this kernel sets it?

Sincerely -- Mark Salyzyn

