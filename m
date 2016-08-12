From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [RFC] libata-scsi: make sure Maximum Write Same Length is not too large
Date: Fri, 12 Aug 2016 13:02:42 +0800
Message-ID: <CAGnHSE=E1Bj99EciXrDS31n4Q4VcRL0sDJ2t4ynx0bHgp5RNtw@mail.gmail.com>
References: <833713246c1a70d85150289c1537797d6f7dd606.1470903899.git.tom.ty89@gmail.com>
 <yq1r39upy7p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <yq1r39upy7p.fsf@sermon.lab.mkp.net>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, Shaun Tancheff <shaun.tancheff@seagate.com>, Shaun Tancheff <shaun@tancheff.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 12 August 2016 at 09:34, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Tom," == tom ty89 <tom.ty89@gmail.com> writes:
>
> Tom,
>
> +               put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM /
> +                                  (sector_size / 512), &rbuf[36]);
>
> MAXIMUM WRITE SAME LENGTH is in units of the device's logical block
> size.

Yeah that's why:

+       sector_size = ata_id_logical_sector_size(args->id);

Where the logical sector size of the device is reported with the same
function in ata_scsi_dev_config() and ata_scsiop_read_cap().

So were you trying to pointing out something I am still missing, or
were you merely confirming I was right?

>
> --
> Martin K. Petersen      Oracle Linux Engineering
