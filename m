From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 2/3] scsi_debug: fix NULL pointer dereference with
 parameters dif=0 dix=1
Date: Sat, 27 Apr 2013 17:37:39 +0900
Message-ID: <CAC5umygV+Dregh-hACW1yVzQMfPcQYc7jBpUZ59ptht+n4SCWQ@mail.gmail.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
	<1366535879-20775-3-git-send-email-akinobu.mita@gmail.com>
	<yq1sj2fs5p7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40174 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab3D0Ihj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Apr 2013 04:37:39 -0400
Received: by mail-ob0-f178.google.com with SMTP id 16so4249164obc.9
        for <linux-scsi@vger.kernel.org>; Sat, 27 Apr 2013 01:37:39 -0700 (PDT)
In-Reply-To: <yq1sj2fs5p7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

2013/4/25 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:
>
> Akinobu> The protection info dif_storep is allocated only when parameter
> Akinobu> dif is not zero.  But it will be accessed when reading or
> Akinobu> writing to the storage installed with parameter dix is not
> Akinobu> zero.
>
> Akinobu> So kernel crashes if scsi_debug module is loaded with
> Akinobu> parameters dix=1 and dif=0.
>
> The full story is that scsi_debug does not support DIF and DIX correctly
> by virtue of simultaneously being the HBA and the target. And since
> there is no actual data transfer between the HBA and the target the
> notion of DIF is weak at best.
>
> I did look into making scsi_debug do the right thing but it's quite a
> bit of code and I lost interest about halfway through the effort. If
> you'd like to fix this properly I can probably find the patch to use as
> baseline?

I'm interested in the patch.  So could you provide it?
