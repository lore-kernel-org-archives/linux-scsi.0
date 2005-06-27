From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: shutdown notification (update)
Date: Mon, 27 Jun 2005 08:01:59 -0700
Message-ID: <1119884519.22704.15.camel@markh1.pdx.osdl.net>
References: <1119883177.22704.12.camel@markh1.pdx.osdl.net>
	 <42C014A0.3050301@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:61863 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262092AbVF0PCF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 11:02:05 -0400
In-Reply-To: <42C014A0.3050301@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-06-27 at 10:00 -0500, Brian King wrote:
> Mark Haverkamp wrote:
> 
> > @@ -867,6 +876,9 @@ static struct pci_driver aac_pci_driver 
> >  	.id_table	= aac_pci_tbl,
> >  	.probe		= aac_probe_one,
> >  	.remove		= __devexit_p(aac_remove_one),
> > +	.driver		= {
> > +		.shutdown = aac_shutdown,
> > +	},
> >  };
> 
> Sorry to nitpick, but there is a shutdown function pointer in the
> pci_driver struct now (not just in the device_driver struct) that all
> drivers should probably be migrating to.

OK, thanks.  I had just used another driver for a model.

Mark.

> 
> 
-- 
Mark Haverkamp <markh@osdl.org>

