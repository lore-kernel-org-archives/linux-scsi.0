From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH v1 3/3] scsi: ufs-qcom: update configuration option of
 SCSI_UFS_QCOM component
Date: Wed, 20 May 2015 10:22:35 +0200
Message-ID: <1432110155.21715.45.camel@x220>
References: <1432043231-31102-1-git-send-email-ygardi@codeaurora.org>
	 <1432043231-31102-4-git-send-email-ygardi@codeaurora.org>
	 <1432106479.21715.33.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1432106479.21715.33.camel@x220>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, kishon@ti.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, gbroner@codeaurora.org, dovl@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-05-20 at 09:21 +0200, Paul Bolle wrote:
> As far as I can see, in next-20150519, drivers/scsi/ufs/ufs-qcom.c lacks
> the required module specific boilerplate for this to be useful. Is that
> boilerplate added in another series?

I need to rephrase this. Let me try again.

As far as I can see, in next-20150519, drivers/scsi/ufs/ufs-qcom.c lacks
a MODULE_LICENSE() macro. Without that macro loading the module should
trigger a warning and taint the kernel, right?

By the way, as far as I can see, this (new) module can only be loaded
manually (or via scripts). Is that what people want?

Thanks,


Paul Bolle
