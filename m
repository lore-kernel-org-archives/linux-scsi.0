From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 3/3] scsi: ufs-qcom: update configuration option of
 SCSI_UFS_QCOM component
Date: Thu, 21 May 2015 10:09:34 -0000
Message-ID: <13293a67c19b0c18d2c99386dcf159ea.squirrel@www.codeaurora.org>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
    <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
    <1432106479.21715.33.camel@x220> <1432110155.21715.45.camel@x220>
    <1432192570.21715.107.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1432192570.21715.107.camel@x220>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> On Wed, 2015-05-20 at 10:22 +0200, Paul Bolle wrote:
>> By the way, as far as I can see, this (new) module can only be loaded
>> manually (or via scripts). Is that what people want?
>
> This comment wasn't well thought through. So I hand another look at the
> code of usf-qcom.
>
> I noticed that the single thing ufs-qcom exports is "struct
> ufs_hba_qcom_vops". But that's unused in next-20150520:
>     $ git grep -nw ufs_hba_qcom_vops
>     drivers/scsi/ufs/ufs-qcom.c:999: * struct ufs_hba_qcom_vops - UFS QCOM
> specific variant operations
>     drivers/scsi/ufs/ufs-qcom.c:1004:static const struct
> ufs_hba_variant_ops ufs_hba_qcom_vops = {
>     drivers/scsi/ufs/ufs-qcom.c:1016:EXPORT_SYMBOL(ufs_hba_qcom_vops);
>
> So it's not used by code outside of ufs-qcom.c. Probably because it
> can't actually be used by outside code. It's not mentioned in any public
> header and it's even static!
>
> Am I missing something obvious here? Because ufs-qcom currently looks
> pointless to me, and I actually see little reason to even have it in the
> mainline tree.
>

we haven't uploaded yet the patch that binds qcom vops to the driver, but
we will soon.

>
> Paul Bolle
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
