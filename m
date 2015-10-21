From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 07/15] scsi: ufs: set REQUEST_SENSE command size to 18 bytes
Date: Wed, 21 Oct 2015 23:51:10 +0900
Message-ID: <CAC5umyjOcU-Do39XjoghwpF5WGBzxrFgS2nVjrD93ALLcnVPNQ@mail.gmail.com>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
	<1441188795-4600-8-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1441188795-4600-8-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
> According to UFS device specification REQUEST_SENSE command can
> only report back up to 18 bytes of data.
>
> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufshcd.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0e54183..217b5cf 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -42,6 +42,7 @@
>
>  #include "ufshcd.h"
>  #include "unipro.h"
> +#define UFSHCD_REQ_SENSE_SIZE  18

We usually put a blank line between #include and #define.
