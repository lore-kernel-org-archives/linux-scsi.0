From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data
 integrity support
Date: Sat, 8 Jun 2013 23:53:05 +0900
Message-ID: <CAC5umygKR4J4Y8FP-0WMvpiZc=yL2jdtJopFZvBXP3c6AEgjHg@mail.gmail.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
	<51A5057F.9030703@interlog.com>
	<yq1k3mi3nby.fsf@sermon.lab.mkp.net>
	<CAC5umyiW02vB-bbhCic=zU8CxaQY-AebQ0PCj1eTCifAUHortg@mail.gmail.com>
	<yq1y5ammyux.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46938 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3FHOxH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Jun 2013 10:53:07 -0400
Received: by mail-oa0-f41.google.com with SMTP id n9so4396522oag.14
        for <linux-scsi@vger.kernel.org>; Sat, 08 Jun 2013 07:53:05 -0700 (PDT)
In-Reply-To: <yq1y5ammyux.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>

2013/6/7 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Akinobu" == Akinobu Mita <akinobu.mita@gmail.com> writes:
>
> Akinobu> So Martin and Douglas, can I have your ACKs on this patch
> Akinobu> series for now?
>
> Only concern is the one I mentioned before: You're mapping and unmapping
> the ppage for every 8 bytes of protection information. That seems a bit
> excessive.

I understand your concern.  That could be cured by changing the outer loop from
'scsi_for_each_sg' to 'scsi_for_each_prot_sg'.  I'll try to do this and see
how it looks.

> However, I personally don't care too much about 32-bit platforms, so...
>
> Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Thanks.
