From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: Re: [PATCH v1 2/4] scsi: ufs: add debugfs for ufs
Date: Tue, 10 Feb 2015 14:05:10 -0000
Message-ID: <d3435b8ff38fb890e22f4f3a5521d524.squirrel@codeaurora.org>
References: <1422977841-25036-1-git-send-email-gbroner@codeaurora.org>
    <1422977841-25036-3-git-send-email-gbroner@codeaurora.org>
    <CAC5umyiQYWLVn-=VyOw1cdiGdukFhh3uBTj78djb67pugYZu-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAC5umyiQYWLVn-=VyOw1cdiGdukFhh3uBTj78djb67pugYZu-w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Gilad Broner <gbroner@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Lee Susman <lsusman@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

> Should we append the index for unique directory
> name for each contoroller like "ufs0", "ufs1", ...?

I agree - uploaded patch V2 in which this is handled.

Thanks,
Gilad.

-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
