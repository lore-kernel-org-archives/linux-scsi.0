From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] [SCSI] aacraid: use lower snprintf() limit
Date: Thu, 6 Oct 2011 17:27:58 +0300
Message-ID: <20111006142758.GB18470@longonot.mountain>
References: <20111005055046.GD32077@elgon.mountain>
 <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35632 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1JFObV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2011 10:31:21 -0400
Content-Disposition: inline
In-Reply-To: <d97a34694e741dc6a2a71fbcd49bab49.squirrel@webmail.sf-mail.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Wed, Oct 05, 2011 at 09:35:13AM +0200, Rolf Eike Beer wrote:
> >  		  dev->supplement_adapter_info.MfgPcbaSerialNo);
> > +
> > +
> 
> One newline too much.
> 

True.  I wish checkpatch.pl checked for that...

> > +	if (len > 16)
> > +		len = 16;
> 
> max()?

min() actually.  I don't know that it improves the readability, but
can do.

regards,
dan carpenter
