From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [RESEND][PATCH 8/8][SCSI]mpt3sas: Bump mpt3sas driver version to 04.100.00.00
Date: Fri, 22 Aug 2014 21:12:20 +0530
Message-ID: <CAK=zhgqWWKu4bNw3WB3cG120cC5fXcVfjRaigdARxnHa=maeQw@mail.gmail.com>
References: <20140625104207.GA13042@avagotech.com>
	<yq1a98av9vi.fsf@sermon.lab.mkp.net>
	<CAK=zhgqGVBsgxheZ1ixvGEeOFJ_7fPhO0d4HAh1f4YD1mWG7Sw@mail.gmail.com>
	<yq1k361r1l7.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:42206 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaHVPmW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2014 11:42:22 -0400
Received: by mail-qc0-f172.google.com with SMTP id i8so10930469qcq.17
        for <linux-scsi@vger.kernel.org>; Fri, 22 Aug 2014 08:42:21 -0700 (PDT)
In-Reply-To: <yq1k361r1l7.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Hi Martin,

Today I was busy with the internal activity. By Monday I will repost
this patch with requested changes.

Thanks,
Sreekanth

On Fri, Aug 22, 2014 at 2:40 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:
>
> Sreekanth> 1. [RESEND][PATCH 7/8][SCSI]mpt3sas: Added Reply Descriptor
> Sreekanth>    Post Queue (RDPQ) Array support
>
> Please make the change suggested by Joe Perches and then repost both
> mpt2sas and mpt3sas with the appropriate SoB and RB tags so they are
> easy for Christoph to pick up.
>
> The only patch I'd like to dig deeper into before accepting it is the
> unblock one.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
