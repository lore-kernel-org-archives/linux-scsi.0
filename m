From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH V2] mpt3sas: disable ASPM for MPI2 controllers
Date: Fri, 6 Jan 2017 21:18:06 +0530
Message-ID: <CAK=zhgoocwB_01KT8UjtNXwTwcBQ86zWwMB3R4pjW3STy-7iyg@mail.gmail.com>
References: <20161228110524.7516-1-ojab@ojab.ru> <yq17f69hs1l.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:35575 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966232AbdAFPsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2017 10:48:09 -0500
Received: by mail-qk0-f170.google.com with SMTP id u25so462858115qki.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2017 07:48:08 -0800 (PST)
In-Reply-To: <yq17f69hs1l.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: ojab <ojab@ojab.ru>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Jan 6, 2017 at 7:24 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "ojab" == ojab  <ojab@ojab.ru> writes:
>
> ojab> MPI2 controllers sometimes got lost (i. e. disappears from
> ojab> /sys/bus/pci/devices) if ASMP is enabled.
>
> Broadcom folks: Please comment!

Matin, We need some time to review this patch. I will provide my
review comments by end of next week.

Thanks,
Sreekanth
>
> --
> Martin K. Petersen      Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
