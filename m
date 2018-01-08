From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v7 0/5] scsi: ufs: add ufs driver code for Hisilicon
 Hi3660 SoC
Date: Mon, 8 Jan 2018 09:39:37 +0800
Message-ID: <127f93dd-29c8-8cfc-9b02-5dc72609a272@linaro.org>
References: <20180106095117.67907-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180106095117.67907-1-liwei213@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Li Wei <liwei213@huawei.com>, robh+dt@kernel.org, mark.rutland@arm.com, xuwei5@hisilicon.com, catalin.marinas@arm.com, will.deacon@arm.com, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, khilman@baylibre.com, arnd@arndb.de, gregory.clement@free-electrons.com, thomas.petazzoni@free-electrons.com, yamada.masahiro@socionext.com, riku.voipio@linaro.org, treding@nvidia.com, krzk@kernel.org, eric@anholt.net, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org
Cc: zangleigang@hisilicon.com, gengjianfeng@hisilicon.com, guodong.xu@linaro.org, fengbaopeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

Hi, Wei


On 2018年01月06日 17:51, Li Wei wrote:
> This patchset adds driver support for UFS for Hi3660 SoC. It is verified on HiKey960 board.
Usually here should list the change compared with the last change set, 
to make it easier
to reviewer, who may pay more attention to the differences.

For example
v7:xxx //change since v6
v6:xxx // change since v5



> Li Wei (5):
>    scsi: ufs: add Hisilicon ufs driver code
>    dt-bindings: scsi: ufs: add document for hisi-ufs
>    arm64: dts: add ufs dts node
>    arm64: defconfig: enable configs for Hisilicon ufs
>    arm64: defconfig: enable f2fs and squashfs
>
>   Documentation/devicetree/bindings/ufs/ufs-hisi.txt |  43 ++
>   arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |  20 +
>   arch/arm64/configs/defconfig                       |  11 +
>   drivers/scsi/ufs/Kconfig                           |   9 +
>   drivers/scsi/ufs/Makefile                          |   1 +
>   drivers/scsi/ufs/ufs-hisi.c                        | 621 +++++++++++++++++++++
>   drivers/scsi/ufs/ufs-hisi.h                        | 116 ++++
>   7 files changed, 821 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
>   create mode 100644 drivers/scsi/ufs/ufs-hisi.c
>   create mode 100644 drivers/scsi/ufs/ufs-hisi.h
>
