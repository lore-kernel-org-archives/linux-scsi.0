From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Wed, 27 Jan 2016 18:02:11 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F923F@BBYEXM01.pmc-sierra.internal>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	<1452842182-684-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	<569E60E4.4000903@redhat.com>
	<198D06D448A18D4E93F08FB849C4E39D7D1F6AA9@BBYEXM01.pmc-sierra.internal>
	<56A22B49.1040702@redhat.com> <yq1h9hzhhxc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:38392 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933892AbcA0SCN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jan 2016 13:02:13 -0500
In-Reply-To: <yq1h9hzhhxc.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

Hello Martin,

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, January 26, 2016 6:31 PM
> To: Raghava Aditya Renukunta
> Cc: Tomas Henzl; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org; Mahesh
> Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-sierra.com; Scott
> Benesh; jthumshirn@suse.de; shane.seymour@hpe.com; zzzDavid Carroll
> Subject: Re: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
> 
> >>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:
> 
> >> 2.Since commands are sync , place a check in aac_fib_send to block
> >> commands once adapter_shutdown is set(only shutdown command will
> be
> >> sent thru)
> 
> Tomas> This option looks better but I guess you still can find a tiny
> Tomas> race window.  What do you think about a mutual exclusive access
> Tomas> using a mutex, do you think this could work?
> 
> [...]
> 
> Raghava?

I have replied that I will create a new set patches with this change shortly. 
Please expect it by tomorrow at the latest.

Regards,
Raghava Aditya

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
