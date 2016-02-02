From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V4 0/9] aacraid: Patchset for aacraid driver version 41052
Date: Mon, 01 Feb 2016 19:56:54 -0500
Message-ID: <yq1d1sgorop.fsf@sermon.lab.mkp.net>
References: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbcBBBCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 20:02:15 -0500
In-Reply-To: <1454107550-24173-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	(Raghava Aditya Renukunta's message of "Fri, 29 Jan 2016 14:45:41
	-0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, shane.seymour@hpe.com

>>>>> "Raghava" == Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com> writes:

Raghava,

Raghava> This patchset includes the following changes (bug fixes and new
Raghava> feature support) specific to aacraid driver.

Please fix the build failure in patch 3/9 when CONFIG_PM is not defined
and address Tomas' comments for 7/9.

-- 
Martin K. Petersen	Oracle Linux Engineering
