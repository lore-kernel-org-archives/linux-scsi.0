From: "Achim Leubner" <Achim_Leubner@pmc-sierra.com>
Subject: RE: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if adapter only supports 31
Date: Thu, 29 Jul 2010 03:09:31 -0700
Message-ID: <FD2BDBE06AC58549AE9E16C08B45675D03B14F73@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
References: <201007260807.45533.eike-kernel@sf-tec.de> <FD2BDBE06AC58549AE9E16C08B45675D03B14F61@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <201007261746.29454.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60749 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756166Ab0G2KJj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 06:09:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <201007261746.29454.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Julia Lawall <julia@diku.dk>

Looks reasonable too. I can also give an Acked-by for Julias patch.

Thanks,
Achim

-----Original Message-----
From: Rolf Eike Beer [mailto:eike-kernel@sf-tec.de] 
Sent: Monday, July 26, 2010 5:46 PM
To: Achim Leubner
Cc: aacraid@adaptec.com; linux-scsi@vger.kernel.org; Andrew Morton;
Julia Lawall
Subject: Re: [PATCH][Resend #2] Do not set DMA mask to 32 bit first if
adapter only supports 31

Achim Leubner wrote:
> Hi Rolf,
> 
> The patch looks good for me so from my side we can include it. Sorry
for
> the delay - I will try to give quick answers for future requests.
Please
> pay attention that my personal email address has changed because we
are
> now part of PMC-Sierra Inc. But aacraid@adaptec.com remains active.

Can I get an Acked-by of any of you so James can push this for the next
merge 
window?

Also please have a look at the patch at

http://marc.info/?l=linux-scsi&m=127472836901937&w=2

and give that an Acked-by, too.

Eike
