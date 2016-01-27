From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH V3 7/9] aacraid: Fix AIF triggered IOP_RESET
Date: Tue, 26 Jan 2016 21:31:27 -0500
Message-ID: <yq1h9hzhhxc.fsf@sermon.lab.mkp.net>
References: <1452842182-684-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	<1452842182-684-8-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
	<569E60E4.4000903@redhat.com>
	<198D06D448A18D4E93F08FB849C4E39D7D1F6AA9@BBYEXM01.pmc-sierra.internal>
	<56A22B49.1040702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25309 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbcA0Cgk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2016 21:36:40 -0500
In-Reply-To: <56A22B49.1040702@redhat.com> (Tomas Henzl's message of "Fri, 22
	Jan 2016 14:14:49 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Cc: Tomas Henzl <thenzl@redhat.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Gana Sridaran <Gana.Sridaran@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Scott Benesh <Scott.Benesh@pmcs.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "shane.seymour@hpe.com" <shane.seymour@hpe.com>, zzzDavid Carroll <David.Carroll@pmcs.com>

>>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:

>> 2.Since commands are sync , place a check in aac_fib_send to block
>> commands once adapter_shutdown is set(only shutdown command will be
>> sent thru)

Tomas> This option looks better but I guess you still can find a tiny
Tomas> race window.  What do you think about a mutual exclusive access
Tomas> using a mutex, do you think this could work?

[...]

Raghava?

-- 
Martin K. Petersen	Oracle Linux Engineering
