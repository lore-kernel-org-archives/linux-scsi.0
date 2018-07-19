From: x00249684 <xuwei5@huawei.com>
Subject: Re: [PATCH v11 3/4] [RESEND] arm64: dts: add ufs dts node
Date: Thu, 19 Jul 2018 17:40:41 +0800
Message-ID: <1531993241-173790-1-git-send-email-xuwei5@huawei.com>
References: <20180717093659.103263-4-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717093659.103263-4-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: liwei213@huawei.com
Cc: robh+dt@kernel.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, sunzhaosheng@hisilicon.com, ian.rickards@arm.com, guodong.xu@linaro.org, puck.chen@hisilicon.com, john.stultz@linaro.org, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

>From: Li Wei <liwei213@huawei.com>
>
>arm64: dts: add ufs node for Hisilicon.
>
>Signed-off-by: Li Wei <liwei213@huawei.com>
>Reviewed-by: Rob Herring <robh@kernel.org>
>Tested-by: John Stultz <john.stultz@linaro.org>

Fine to me. Thanks!
Acked-by: Wei Xu <xuwei5@hisilicon.com>

But it will not be so staightforward when applying the patch
since in the recent pull request the hi3660.dtsi has been tidied up.
If it makes inconvenient, I can apply it once the binding is merged.
Thanks!

Best Regards,
Wei
