From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: configurable discard parameters
Date: Sun, 21 Jun 2015 16:05:12 +0800
Message-ID: <CAGnHSEnevg=advtq=CW2FvV5b93GX3kNwrFu587O2V7hf1J8hA@mail.gmail.com>
References: <CAGnHSEmDQ6xaJsw9i=v23BffWQ8RncrgNBsGWy3ziC36QK+9yQ@mail.gmail.com>
	<yq1fv5l9ajd.fsf@sermon.lab.mkp.net>
	<CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36752 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbbFUIFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2015 04:05:14 -0400
In-Reply-To: <CAGnHSEk+=r1CwQaGd9n4nUm3_e3O7GOL_iFDeJTuNyaSq9WFYg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

By the way do you think it could be a bug of libata's SATL anyway?
Like perhaps it should break a single unmap request to multiple ATA
commands? I am not totally sure about it but it looks like there's a
limit of addressed blocks in a single ATA DSM/TRIM command (4 bytes,
which is 65535).

On 21 June 2015 at 15:03, Tom Yan <tom.ty89@gmail.com> wrote:
> On 21 June 2015 at 08:20, Martin K. Petersen <martin.petersen@oracle.com> wrote:
>> It is a SATA-attached drive, it has no block limits VPD. What you are
>> seeing is information prepared by libata's SATL.
>>
>> Because if the vendor got these trivial values wrong there is little to
>> no chance that they implemented discard correctly in their firmware.
>
> I don't get it. So there's a chance that the VPDs is not purely from
> the hardware? Then how can I differentiate them? But then you said
> "the vendor got these trivial values wrong", so were you talking about
> this drive or just for real SCSI drives?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
