From: Mark Lord <lsml@rtr.ca>
Subject: Re: libata:  BLKFLSBUF ioctl broken
Date: Fri, 22 Oct 2004 10:20:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41791728.7060106@rtr.ca>
References: <4178244E.1060906@rtr.ca> <20041022040423.GA28782@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:27015 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S269970AbUJVOUY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 10:20:24 -0400
In-Reply-To: <20041022040423.GA28782@havoc.gtf.org>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

Try issuing a BLKFLSBUF to a SATA drive.
As of 2.6.9 this apparently returns EOPNOTSUPP to userspace.

I don't have any libata controllers here to try it with.
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
