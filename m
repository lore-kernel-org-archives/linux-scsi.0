From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v7 2/8] scsi: ufs-qcom: fix compilation warning if
 compiled as a module
Date: Wed, 2 Sep 2015 15:28:56 -0500
Message-ID: <CAL_JsqKcPD9Kg4DOctPA9vYYHMd6+K_jQR339iiB+rth=HdP_A@mail.gmail.com>
References: <1441205138-12664-1-git-send-email-ygardi@codeaurora.org> <1441205138-12664-3-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1441205138-12664-3-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Jej B <James.Bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, hch@infradead.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 2, 2015 at 9:45 AM, Yaniv Gardi <ygardi@codeaurora.org> wrote:
> This change fixes a compilation warning that happens if SCSI_UFS_QCOM
> is compiled as a module.
> Also this patch fixes an error happens when insmod the module:
> "ufs_qcom: module license 'unspecified' taints kernel."
>
> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 4cdffa4..6c23bbf 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -917,12 +917,15 @@ out:
>
>  #define        ANDROID_BOOT_DEV_MAX    30
>  static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
> -static int get_android_boot_dev(char *str)

What is this Android crap doing in a driver to begin with?

Rob
