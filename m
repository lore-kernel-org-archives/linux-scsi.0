From: Luka Renko <luka.renko@hermes.si>
Subject: RE: SD driver and 8KB HW sector size
Date: Mon, 8 Nov 2004 16:14:04 +0100
Message-ID: <33829B7061BDB84FAD9EB9EA1F5371B401630BFA@tsc.hermes.si>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from guardian.hermes.si ([193.77.5.150]:47888 "EHLO
	guardian.hermes.si") by vger.kernel.org with ESMTP id S261882AbUKHPPB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2004 10:15:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, Luka Renko <luka.renko@hermes.si>
Cc: linux-scsi@vger.kernel.org, Steve McIntyre <smcintyre@software.plasmon.com>, Damjan Lango <damjan.lango@hermes.si>

2.5.10-rc1 looks OK (cannot reproduce). Thanks for info.

Regards,
Luka 

> -----Original Message-----
> From: Brian King [mailto:brking@us.ibm.com] 
> Sent: Friday, October 29, 2004 20:28
> To: Luka Renko
> Cc: linux-scsi@vger.kernel.org; Steve McIntyre; Damjan Lango
> Subject: Re: SD driver and 8KB HW sector size
> 
> Please try a 2.6.10-rc1 kernel. There was a fix that went in 
> recently for a problem I ran into that should fix your 
> problem as well.
> 
> -Brian
> 
