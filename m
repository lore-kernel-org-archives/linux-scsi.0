From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V2 0/9] aacraid: Patchset for aacraid driver version 41052
Date: Mon, 04 Jan 2016 21:07:33 -0500
Message-ID: <yq1h9islqxm.fsf@sermon.lab.mkp.net>
References: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28140 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbcAECIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2016 21:08:04 -0500
In-Reply-To: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	(Raghava Aditya Renukunta's message of "Thu, 10 Dec 2015 10:45:50
	-0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com

>>>>> "Raghava" == Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com> writes:

Raghava> This patchset includes the following changes (bug fixes and new
Raghava> feature support) specific to aacraid driver.

Raghava> V2: Removed aac_fib_free_tag function Setup relevant fib
Raghava> variables only in once Created aac_fib_vector_assign function
Raghava> Made EEH functions static Added character device status macros
Raghava> Changed location of aac->shutdown to prevent race condition
Raghava> Withdrew patch that disables device ID wild card binding

You dropped all the review/fix/stable tags you had received from Tomas
and Johannes.

Please apply the relevant tags and resubmit this series.

-- 
Martin K. Petersen	Oracle Linux Engineering
