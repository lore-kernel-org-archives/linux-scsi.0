From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 13:40:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41794627.60407@rtr.ca>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org>	 <41791728.7060106@rtr.ca>  <41793E68.6010000@pobox.com> <1098461668.19463.22.camel@localhost.localdomain> <41794158.9010308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:56711 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S266319AbUJVRk5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 13:40:57 -0400
In-Reply-To: <41794158.9010308@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>

The best I can find (with a quick google) is:

http://www.opengroup.org/onlinepubs/009695399/basedefs/errno.h.html

[ENOTTY]
     Inappropriate I/O control operation.
[EOPNOTSUPP]
     Operation not supported on socket.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
