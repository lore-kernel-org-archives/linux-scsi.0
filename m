From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 13:20:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41794158.9010308@pobox.com>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org>	 <41791728.7060106@rtr.ca>  <41793E68.6010000@pobox.com> <1098461668.19463.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64942 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267263AbUJVRUh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 13:20:37 -0400
In-Reply-To: <1098461668.19463.22.camel@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Mark Lord <lsml@rtr.ca>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

Alan Cox wrote:
> libata should be returning -ENOTTY "I don't know what you are talking
> about", and the core block layer will then fallback and do generic
> handling
> 
> -EOPNOTSUPP is saying "I do know what is going on but its broken so
> fail it totally".

Are you describing behavior mandated in some standard?

Because that differs with _tons_ of existing ioctl code, whose default 
return code is EOPNOTSUPP when no known operation is found in a C 
"switch(cmd)" statement.

grep for it...

	Jeff


