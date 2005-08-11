From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] start stop libata attached SATA disks, take 2
Date: Thu, 11 Aug 2005 00:01:41 -0400
Message-ID: <42FACDA5.5090908@pobox.com>
References: <42F4746B.6030303@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:18595 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932239AbVHKEBo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 00:01:44 -0400
In-Reply-To: <42F4746B.6030303@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Jeff,
> Here is another (more successful) attempt at that patch.
> 
> ChangeLog:
>   - adds minimal START STOP UNIT SCSI command functionality
>     to libata (follows sat-r05 apart from the IMMED bit).
>   - implements the TEST UNIT READY SCSI command as indicated
>     by sat-r05.

> Signed-off-by: Douglas Gilbert <dougg@torque.net>

Looks pretty decent, however...

Can you please resend as two patches:

#1: implement START STOP UNIT
#2: implement TEST UNIT READY

I need to think about TUR a bit more.  Separating into two patches would 
allow me to apply SSU patch to upstream immediately, while applying the 
TUR feature to libata-dev.git respository, queueing it for further 
review and eventual upstream merge.

	Jeff



