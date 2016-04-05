From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 03/12] BUG: Losing bits on request.cmd_flags
Date: Tue, 5 Apr 2016 17:39:05 +0700
Message-ID: <CAJVOszBXs1hw9ng6=-jVBJs+3JaTaybF0XcM+Cn8Y_Ddh5xDTg@mail.gmail.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
 <1459746376-27983-4-git-send-email-shaun@tancheff.com> <x49pou5s6yg.fsf@segfault.boston.devel.redhat.com>
 <CAJVOszAK5w4qsrKcUot8rm9nZ65hXeUm5YomQU3fT-fARCGXjA@mail.gmail.com> <yq1zit8bydp.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:3688 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbcDEKj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2016 06:39:26 -0400
Received: from pps.filterd (m0075553.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u35AbuZM010746
	for <linux-scsi@vger.kernel.org>; Tue, 5 Apr 2016 06:39:25 -0400
Received: from mail-yw0-f171.google.com (mail-yw0-f171.google.com [209.85.161.171])
	by mx0a-00003501.pphosted.com with ESMTP id 224brsr0ky-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2016 06:39:25 -0400
Received: by mail-yw0-f171.google.com with SMTP id i84so4888202ywc.2
        for <linux-scsi@vger.kernel.org>; Tue, 05 Apr 2016 03:39:25 -0700 (PDT)
In-Reply-To: <yq1zit8bydp.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>

On Tue, Apr 5, 2016 at 9:08 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Shaun" == Shaun Tancheff <shaun.tancheff@seagate.com> writes:
>
> Shaun> Oh, okay. It became an issue in the next patch where some
> Shaun> internal cmd_flags temporaries where stored in 32 bit values.
>
> Shaun> I will fix patch/subject.
>
> There's a pending patch set from Mike Christie that cleans all this
> up. Please use that as baseline.

Given Mike Christie's patches this is not needed.
Thanks!

> --
> Martin K. Petersen      Oracle Linux Engineering
-- 
Shaun Tancheff
