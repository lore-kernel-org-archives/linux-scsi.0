From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v2 2/4] scsi: ufs: add debugfs for ufs
Date: Sun, 22 Feb 2015 15:00:21 -0000
Message-ID: <bfd83fb637774cb3f732f926423f8b2b.squirrel@codeaurora.org>
References: <1423576735-26267-1-git-send-email-gbroner@codeaurora.org>
    <1423576735-26267-3-git-send-email-gbroner@codeaurora.org>
    <CAC5umyhX0peGYyh49rb9TPHK4=+s_UT6WFSTVv0cXpycAuu4kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyhX0peGYyh49rb9TPHK4=+s_UT6WFSTVv0cXpycAuu4kw@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gilad Broner <gbroner@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

> UFSDBG_REMOVE_DEBUGFS() is not called in the driver unloading path.
> So ufs debugfs directory is not removed when unloading driver.  It
> should be called in ufshcd_remove().
>
> BTW, do we really need UFSDBG_ADD_DEBUGFS() and UFSDBG_REMOVE_DEBUGFS()
> macros?
> We can use static inline functions in ufs-debugfs.h when !CONFIG_DEBUG_FS.
>
> #ifdef CONFIG_DEBUG_FS
> void ufsdbg_add_debugfs(struct ufs_hba *hba);
>
> void ufsdbg_remove_debugfs(struct ufs_hba *hba);
> #else
> static inline void ufsdbg_add_debugfs(struct ufs_hba *hba)
> {
> }
>
> static inline void ufsdbg_remove_debugfs(struct ufs_hba *hba)
> {
> }
> #endif
>

Thanks, I will fix the above two points and upload another patch.

Gilad.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
