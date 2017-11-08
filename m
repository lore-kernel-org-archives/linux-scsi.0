From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH] scsi: megaraid: Convert timers to use timer_setup()
Date: Wed, 8 Nov 2017 21:46:31 +0530
Message-ID: <ac132cbd804bec5892ad38de3afe6a9b@mail.gmail.com>
References: <20171025100720.GA145069@beast> <92b3d37d10162a899d5a829351fd1512@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <92b3d37d10162a899d5a829351fd1512@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, Kees Cook <keescook@chromium.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Sumit Saxena [mailto:sumit.saxena@broadcom.com]
> Sent: Wednesday, November 1, 2017 12:18 AM
> To: Kees Cook; Martin K. Petersen
> Cc: Kashyap Desai; Shivasharan Srikanteshwara; James E.J. Bottomley;
> PDL,MEGARAIDLINUX; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: RE: [PATCH] scsi: megaraid: Convert timers to use timer_setup()
>
> -----Original Message-----
> From: Kees Cook [mailto:keescook@chromium.org]
> Sent: Wednesday, October 25, 2017 3:37 PM
> To: Martin K. Petersen
> Cc: Kashyap Desai; Sumit Saxena; Shivasharan S; James E.J. Bottomley;
> megaraidlinux.pdl@broadcom.com; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] scsi: megaraid: Convert timers to use timer_setup()
>
> In preparation for unconditionally passing the struct timer_list pointer
> to all
> timer callbacks, switch to using the new timer_setup() and
> from_timer() to pass the timer pointer explicitly. Also consolidates the
> timer
> setup functions arguments, which are all identical, and corrects on-stack
> timer
> usage.
>

Ran basic sanity test for megaraid_sas part, and the changes look good.
Acked-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Tested-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Hannes,
Can you please take a look at the megaraid_mbox and megaraid_mm changes?

Thanks,
Shivasharan
