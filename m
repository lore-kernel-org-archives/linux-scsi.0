From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 07/22] [SCSI] mpt2sas: Complete the SCSI command with
 DID_RESET status for log_info value 0x0x32010081
Date: Thu, 11 Dec 2014 17:48:18 +0530
Message-ID: <CAK=zhgr5h7_uTQRfXgXeyLtEf-_zReem4oGEzROnRoHDYaw-hA@mail.gmail.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1416467155-16869-8-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1a934i055.fsf@sermon.lab.mkp.net>
	<CAK=zhgr-+MaT6UeXR96G-nMGfo8RdmHVRN1wkUKjz7h6gwLNhg@mail.gmail.com>
	<yq161djdyrd.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:41436 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaLKMSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2014 07:18:25 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so6210602wgg.11
        for <linux-scsi@vger.kernel.org>; Thu, 11 Dec 2014 04:18:19 -0800 (PST)
In-Reply-To: <yq161djdyrd.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> Sreekanth> For any SCSI command, if the driver receives IOC status =
> Sreekanth> SCSI_IOC_TERMINATED and log info = 0x32010081 then that
> Sreekanth> command will be completed with DID_RESET host status.
>>>
>>> What does that log info value mean?
>
> Sreekanth> The meaning of this log info value is "Virtual IO has failed
> Sreekanth> and has to be retried".
>
> OK, I'd prefer to see that documented in the patch.

Ok sure Martin, I will add this description in the next version of
this patch once review completes on this patch set.

Thanks,
Sreekanth
