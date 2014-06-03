From: =?UTF-8?Q?Andreas_Gr=C3=BCnbacher?= <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH] [SCSI] Fix T10-DIF-TYPE3 get_tag handler for multi-sector bios
Date: Wed, 4 Jun 2014 01:29:28 +0200
Message-ID: <CAHpGcM+VPzOOWzPqf58r20Z78eoFBQtBPhUzoqtqva=guTy8jg@mail.gmail.com>
References: <1401294293-18770-1-git-send-email-andreas.gruenbacher@gmail.com>
	<yq1k38x38wz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:56456 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245AbaFCX32 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jun 2014 19:29:28 -0400
Received: by mail-ve0-f180.google.com with SMTP id db12so7722594veb.25
        for <linux-scsi@vger.kernel.org>; Tue, 03 Jun 2014 16:29:28 -0700 (PDT)
In-Reply-To: <yq1k38x38wz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Martin,

2014-06-04 0:50 GMT+02:00 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Andreas" == Andreas Gruenbacher <andreas.gruenbacher@gmail.com> writes:
>
> Andreas,
>
> Andreas> The combined tag size in this case is 6 bytes; fix the loop.
>
> I just posted a patch series that removes the tagging functions because
> nobody was using them. Are you?

No, I just stumbled upon this in the code.

Thanks for letting me know that this is obsolete.

Andreas
