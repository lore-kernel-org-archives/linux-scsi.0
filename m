From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V2 0/9] aacraid: Patchset for aacraid driver version
 41052
Date: Wed, 6 Jan 2016 23:01:38 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1F37ED@BBYEXM01.pmc-sierra.internal>
References: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <yq1h9islqxm.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:39598 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbcAFXBk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jan 2016 18:01:40 -0500
In-Reply-To: <yq1h9islqxm.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>

Hello Martin,

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, January 4, 2016 6:08 PM
> To: Raghava Aditya Renukunta
> Cc: JBottomley@Parallels.com; linux-scsi@vger.kernel.org; Mahesh
> Rajashekhara; Murthy Bhat; zzzSantosh Akula; Gana Sridaran; aacraid@pmc-
> sierra.com; Scott Benesh
> Subject: Re: [PATCH V2 0/9] aacraid: Patchset for aacraid driver version 41052
> 
> >>>>> "Raghava" == Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@pmcs.com> writes:
> 
> Raghava> This patchset includes the following changes (bug fixes and new
> Raghava> feature support) specific to aacraid driver.
> 
> Raghava> V2: Removed aac_fib_free_tag function Setup relevant fib
> Raghava> variables only in once Created aac_fib_vector_assign function
> Raghava> Made EEH functions static Added character device status macros
> Raghava> Changed location of aac->shutdown to prevent race condition
> Raghava> Withdrew patch that disables device ID wild card binding
> 
> You dropped all the review/fix/stable tags you had received from Tomas
> and Johannes.
> 
> Please apply the relevant tags and resubmit this series.

Thank you for pointing that out I will resubmit this series with necessary changes.

Regards,
Raghava Aditya

> 
> --
> Martin K. Petersen	Oracle Linux Engineering
