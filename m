From: Mark Lord <lsml@rtr.ca>
Subject: Re: [PATCH] QStor SATA/RAID v.96 for 2.6.9-rc2
Date: Tue, 21 Sep 2004 15:21:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41507F21.8010800@rtr.ca>
References: <4150666A.90807@rtr.ca> <41506BBE.2050507@rtr.ca> <4150712F.3080504@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:9123 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S267998AbUIUTWr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 15:22:47 -0400
In-Reply-To: <4150712F.3080504@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
>
> Where is this seperate RAID management module?  :)
> 
> Typically we do not add kernel hooks to non-public stuff...

It is still under development.  The vendor will likely
distribute it in source code form with the product installation disk,
since it is likely to undergo far more frequent updates that the
base kernel driver.

This allows them to decouple the portion not needed at boot-time,
from the more difficult to change kernel code that has to be
there to boot the system on RAID.

Cheers
-- 
Mark Lord
(hdparm keeper & the original "Linux IDE Guy")
