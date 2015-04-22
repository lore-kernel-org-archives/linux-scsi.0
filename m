From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Wed, 22 Apr 2015 17:02:03 +0530
Message-ID: <3224b33c001a84f19fc033e0d55422a1@mail.gmail.com>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com> <20150421104210.GC8920@infradead.org>
 e1ce6d2a2c88186f3d665bd9d8133c1f@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:33913 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbbDVLcF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2015 07:32:05 -0400
Received: by qkgx75 with SMTP id x75so218646091qkg.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2015 04:32:04 -0700 (PDT)
In-Reply-To: e1ce6d2a2c88186f3d665bd9d8133c1f@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Sumit Saxena [mailto:sumit.saxena@avagotech.com]
>Sent: Tuesday, April 21, 2015 6:03 PM
>To: 'Christoph Hellwig'
>Cc: 'linux-scsi@vger.kernel.org'; 'thenzl@redhat.com';
>'martin.petersen@oracle.com'; 'jbottomley@parallels.com'; Kashyap Desai
>Subject: RE: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag
support
>for internal command indexing
>
>
>
>>-----Original Message-----
>>From: Christoph Hellwig [mailto:hch@infradead.org]
>>Sent: Tuesday, April 21, 2015 4:12 PM
>>To: Sumit.Saxena@avagotech.com
>>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>>martin.petersen@oracle.com; hch@infradead.org;
>>jbottomley@parallels.com; kashyap.desai@avagotech.com
>>Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag
>>support for internal command indexing
>>
>>This patch needs to be split up:  the return_cmd calling convenion
>>changes should be a pach on it's own, the various new debug printks
>>should be a patch on their own, or better jsut be dropped.
>
>I can work on this. Logically, there can be two patches- 1) BLK tag
support 2)
>changes in calling convention of return_cmd (this patch will revert the
changes
>done by patch- 90dc9d9 megaraid_sas : MFI MPT linked list corruption
fix).
>So patch #2 will be very much dependent on patch #1. If someone applies
>patch #2 without applying patch#1, then bug fixed by  "90dc9d9
megaraid_sas
>: MFI MPT linked list corruption fix " will be exposed again.
>That's why I club these two patches in a single patch. Regarding debug
prints,
>that can be removed.

Christoph,
I have started rework for the patches. I will remove debug printks. Can
you please let me know should I go for separate patch for change in
calling convention return_cmd?

Thanks,
Sumit
>>
>>Also please drop the BLK_TAG_REFCOUNT/DEBUG code that shouldn't be
>ina
>>production driver.
