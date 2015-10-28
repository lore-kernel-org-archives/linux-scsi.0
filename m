From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH 01/12] megaraid_sas : Expose TAPE drives unconditionally
Date: Wed, 28 Oct 2015 16:28:54 +0530
Message-ID: <f1c1f29ad47e8c6f25dc3b0317682493@mail.gmail.com>
References: <201510150816.t9F8GgOq029543@palmhbs0.lsi.com> <yq1wpu791v3.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1wpu791v3.fsf@sermon.lab.mkp.net>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, thenzl@redhat.com, hch@infradead.org, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>, Kiran Kumar Kasturi <kiran-kumar.kasturi@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, October 28, 2015 7:44 AM
> To: sumit.saxena@avagotech.com
> Cc: linux-scsi@vger.kernel.org; stable@vger.kernel.org;
thenzl@redhat.com;
> martin.petersen@oracle.com; hch@infradead.org; jbottomley@parallels.com;
> kashyap.desai@avagotech.com; kiran-kumar.kasturi@avagotech.com;
> uday.lingala@avagotech.com
> Subject: Re: [PATCH 01/12] megaraid_sas : Expose TAPE drives
unconditionally
>
>
> Sumit> Expose non-disk(TAPE drive, CD-ROM) unconditionally. This issue
> Sumit> is reported in Redhat Bugzilla [Bug 1254762].
>
> RH bugzilla is not public so I removed this blurb from the patch
description.
>
> In the future, please drop the spaces after megaraid_sas in patch
header. I fixed
> those up for now.
Sure, I will take care of it while sending patches in future.

Thanks,
Sumit
>
> --
> Martin K. Petersen	Oracle Linux Engineering
