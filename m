From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 06/10][SCSI]mpt2sas: For >2TB volumes, DirectDrive support sends IO's with LBA bit 31 to IR FW instead of DirectDrive
Date: Tue, 15 Jul 2014 13:02:11 -0400
Message-ID: <yq161iyv9m4.fsf@sermon.lab.mkp.net>
References: <20140625103418.GA12939@avagotech.com>
	<yq1oawtxoqv.fsf@sermon.lab.mkp.net>
	<CAK=zhgosXeox35kVvuiTm8EZaD2-e_Lxz79uFFAP0c1cMJNbcg@mail.gmail.com>
	<CAK=zhgq6bXRBapfBy+Nx5uFFLUuj1cH78x0RXCU1Vk8Y9NWheA@mail.gmail.com>
	<yq1fvi3y736.fsf@sermon.lab.mkp.net>
	<CAK=zhgrUWOS-pPjamF+z+AZZvdXz_JxyKgdTv6Zae0oLk=qQog@mail.gmail.com>
	<yq1r41mwwlb.fsf@sermon.lab.mkp.net>
	<CAK=zhgrE0QBgyyLTU0Jdq2cAbKbd=wY4zfMGo2ux9nWz9oBgiQ@mail.gmail.com>
	<CAK=zhgpqcFu5WKLEOD9E=K9DURO9HEtXE8VDVpScLiZK+3JsAQ@mail.gmail.com>
	<yq1fvi2wqyq.fsf@sermon.lab.mkp.net>
	<CAK=zhgoNm=STXjBOOqXHaz4yPuRHQ0avwgUOD_H0B==sgt6vEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41055 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbaGORCS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2014 13:02:18 -0400
In-Reply-To: <CAK=zhgoNm=STXjBOOqXHaz4yPuRHQ0avwgUOD_H0B==sgt6vEg@mail.gmail.com>
	(Sreekanth Reddy's message of "Tue, 15 Jul 2014 22:22:25 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Sathya Prakash <sathya.prakash@avagotech.com>, linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth> But still I observe the invalid LBA when we send IOs using
Sreekanth> sg_dd with input file specified as /dev/sg0 as shown below

In the latest patch I get the LBA from CDB32 in the MPI request so that
shouldn't happen.

-- 
Martin K. Petersen	Oracle Linux Engineering
