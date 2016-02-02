From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH V4 0/9] aacraid: Patchset for aacraid driver version
 41052
Date: Tue, 2 Feb 2016 01:19:35 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D1FCBF0@BBYEXM01.pmc-sierra.internal>
References: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
 <yq1d1sgorop.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:56679 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbcBBBTh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2016 20:19:37 -0500
In-Reply-To: <yq1d1sgorop.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "thenzl@redhat.com" <thenzl@redhat.com>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>

Hello Martin,

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Monday, February 1, 2016 4:57 PM
> To: Raghava Aditya Renukunta
> Cc: James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org; Mahesh
> Rajashekhara; Murthy Bhat; Gana Sridaran; aacraid@pmc-sierra.com; Scott
> Benesh; jthumshirn@suse.de; thenzl@redhat.com;
> shane.seymour@hpe.com
> Subject: Re: [PATCH V4 0/9] aacraid: Patchset for aacraid driver version 41052
> 
> >>>>> "Raghava" == Raghava Aditya Renukunta
> <RaghavaAditya.Renukunta@pmcs.com> writes:
> 
> Raghava,
> 
> Raghava> This patchset includes the following changes (bug fixes and new
> Raghava> feature support) specific to aacraid driver.
> 
> Please fix the build failure in patch 3/9 when CONFIG_PM is not defined
> and address Tomas' comments for 7/9.

I will create a new patch version fixing these issues shortly.

Thank you Martin.
Regards,
Raghava Aditya

> --
> Martin K. Petersen	Oracle Linux Engineering
