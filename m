From: Xuewei Zhang <xueweiz@google.com>
Subject: Re: [PATCH] scsi: sd: fix entropy gathering for most rotational disks
Date: Tue, 12 Feb 2019 12:00:18 -0800
Message-ID: <CAPtwhKpqggL1k8wsh-ECS6aUr7qThUyHjgx9BGeL84bCbj9Lvw@mail.gmail.com>
References: <1549987525.3173.17.camel@HansenPartnership.com>
 <e9a411a2-49e2-4897-4e02-1cf790465cbd@kernel.dk> <yq1zhr1t028.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1zhr1t028.fsf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Mikael Pettersson <mikpelinux@gmail.com>, Theodore Tso <tytso@google.com>
List-Id: linux-scsi@vger.kernel.org

Thanks for the fix James!

On Tue, Feb 12, 2019 at 8:59 AM Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>
>
> Jens,
>
> >> The fix is to set the non-rotational and add-randomness flags
> >> unconditionally early on in the disk initialization path, so they can
> >> be reset only if the device actually reports being non-rotational via
> >> the VPD page.
> >
> > Reviewed-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Xuewei Zhang <xueweiz@google.com>

>
> Yeah, this looks good to me. I'll queue it up for fixes.
>
> --
> Martin K. Petersen      Oracle Linux Engineering
