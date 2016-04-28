From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] pm80xx: Phy settings support for motherboard controller.
Date: Wed, 27 Apr 2016 20:03:13 -0400
Message-ID: <yq160v2eh1a.fsf@sermon.lab.mkp.net>
References: <20160413112454.GA25247@mwanda>
	<CAD+HZHXt=+z=+9=Uh7etj8aB3M_kk_sSB+ipc633Bc5caQuaQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27617 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbcD1ADW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2016 20:03:22 -0400
In-Reply-To: <CAD+HZHXt=+z=+9=Uh7etj8aB3M_kk_sSB+ipc633Bc5caQuaQA@mail.gmail.com>
	(Jack Wang's message of "Thu, 14 Apr 2016 14:52:20 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Jack" == Jack Wang <xjtuwjp@gmail.com> writes:

Jack> 2016-04-13 13:24 GMT+02:00 Dan Carpenter
Jack> <dan.carpenter@oracle.com>:
>> Hello Anand Kumar Santhanam,
>> 
>> The patch 279094079a44: "[SCSI] pm80xx: Phy settings support for
>> motherboard controller." from Sep 18, 2013, leads to the following
>> static checker warning:
>> 
>> drivers/scsi/pm8001/pm80xx_hwi.c:4554 mpi_set_phy_profile_req()
>> error: uninitialized symbol 'tag'.
>> 

Jack> Thanks for reporting, attached patch should fix the warning.

Dan: Please review Jack's patch so get can get this in.

-- 
Martin K. Petersen	Oracle Linux Engineering
