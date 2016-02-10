From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2] megaraid_sas: add an i/o barrier
Date: Thu, 11 Feb 2016 00:26:42 +0530
Message-ID: <c31c2e97222cd193a87316ed46bf6ecf@mail.gmail.com>
References: <56AF67B4.2010702@redhat.com> <yq1oaboa362.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1oaboa362.fsf@sermon.lab.mkp.net>
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, Sumit.Saxena@avagotech.com, "Desai, Kashyap" <Kashyap.Desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, stable@vger.kernel.org, kashyap.desai@broadcom.com
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Wednesday, February 10, 2016 10:55 PM
> To: Tomas Henzl
> Cc: 'linux-scsi@vger.kernel.org'; Sumit.Saxena@avagotech.com; Desai,
> Kashyap; Uday Lingala; stable@vger.kernel.org
> Subject: Re: [PATCH v2] megaraid_sas: add an i/o barrier
>
> >>>>> "Tomas" == Tomas Henzl <thenzl@redhat.com> writes:
>
> Tomas> A barrier should be added to ensure proper ordering of memory
> Tomas> mapped writes.
>
> Tomas> V2: - added the barrier also to megasas_fire_cmd_skinny, as
> Tomas> suggested by Kashyap Desai

Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Acked-by: Kashyap Desai <kashyap.desai@broadcom.com>

>
> Sumit, Kashyap: Please review this patch.
>
> --
> Martin K. Petersen	Oracle Linux Engineering
