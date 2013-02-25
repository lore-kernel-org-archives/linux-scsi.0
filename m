From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V6 Resend 3/4] [SCSI] ufs: Add Platform glue driver for
 ufshcd
Date: Mon, 25 Feb 2013 17:05:05 +0000
Message-ID: <1361811905.2384.44.camel@dabdike.int.hansenpartnership.com>
References: <1361808875-2803-1-git-send-email-vinholikatti@gmail.com>
	 <1361808875-2803-4-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1361808875-2803-4-git-send-email-vinholikatti@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, linux-samsung-soc@vger.kernel.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, merez@codeaurora.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-02-25 at 21:44 +0530, Vinayak Holikatti wrote:
> This patch adds Platform glue driver for ufshcd.

Even after fixing the __devXX issues, I still get this:

rivers/scsi/ufs/ufshcd-pltfrm.c:196:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/scsi/ufs/ufshcd-pltfrm.c:196:2: warning: (near initialization
for =E2=80=98ufshcd_dev_pm_ops.suspend=E2=80=99) [enabled by default]
drivers/scsi/ufs/ufshcd-pltfrm.c:197:2: warning: initialization from
incompatible pointer type [enabled by default]
drivers/scsi/ufs/ufshcd-pltfrm.c:197:2: warning: (near initialization
for =E2=80=98ufshcd_dev_pm_ops.resume=E2=80=99) [enabled by default]

That's apparently because the function protoypes are wrong.  I'm not
sure why this is, but I stopped applying here, please fix.

Thanks,

James
