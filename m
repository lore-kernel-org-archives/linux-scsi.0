From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 08/10] aacraid: Disable device ID wildcard
Date: Mon, 7 Dec 2015 19:07:02 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1EFEDC@BBYEXM01.pmc-sierra.internal>
References: <1448973589-9216-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <1448973589-9216-9-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <566065C2.7090603@redhat.com>
 <198D06D448A18D4E93F08FB849C4E39D7D1EF169@BBYEXM01.pmc-sierra.internal>
 <20151204083316.GA32285@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:46995 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755539AbbLGTHE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2015 14:07:04 -0500
In-Reply-To: <20151204083316.GA32285@infradead.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tomas Henzl <thenzl@redhat.com>, "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Santosh Akula <Santosh.Akula@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Rich Bono <Rich.Bono@pmcs.com>

Hello Christoph,

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Friday, December 4, 2015 12:33 AM
> To: Raghava Aditya Renukunta
> Cc: Tomas Henzl; JBottomley@Parallels.com; linux-scsi@vger.kernel.org;
> Mahesh Rajashekhara; Murthy Bhat; Santosh Akula; Gana Sridaran;
> aacraid@pmc-sierra.com; Rich Bono
> Subject: Re: [PATCH 08/10] aacraid: Disable device ID wildcard
> 
> On Thu, Dec 03, 2015 at 09:32:18PM +0000, Raghava Aditya Renukunta wrote:
> > This will enable us to prevent aacraid from loading for PCI devices that
> match
> > device ID wildcards. Enabling us to use say a new driver for future devices.
> 
> This looks like a bogus reason.  The same PCI ID should always be
> compatible and mathed by the same driver.  Even if you add a new driver
> to expose additional feature and break these semantics there is no point
> to do a) reject them conditionally on a module option and b) do this
> before said driver is merged.

I have spoken with my team and  it does make more sense to submit
it when the new driver is merged. I will withdraw this patch.

Regards,
Raghava Aditya
