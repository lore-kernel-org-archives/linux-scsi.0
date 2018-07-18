From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v11 0/4] [RESEND] scsi: ufs: add ufs driver code for
 Hisilicon Hi3660 SoC
Date: Wed, 18 Jul 2018 11:58:06 -0700
Message-ID: <CALAqxLVgRCCPJhjdpqG9TejtdNzHbyasxBytObgrS5_LrQnTtw@mail.gmail.com>
References: <20180717093659.103263-1-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717093659.103263-1-liwei213@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Wei <liwei213@huawei.com>, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, jejb@linux.vnet.ibm.com, Kevin Hilman <khilman@baylibre.com>, Arnd Bergmann <arnd@arndb.de>, Gregory CLEMENT <gregory.clement@free-electrons.com>, Thomas Petazzoni <thomas.petazzoni@free-electrons.com>, yamada.masahiro@socionext.com, Riku Voipio <riku.voipio@linaro.org>, Thierry Reding <treding@nvidia.com>, Krzysztof Kozlowski <krzk@kernel.org>, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, linux-scsi@vger.kernel.org, zangleigang@hisilicon.com, gengjianfeng@hisilicon.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 17, 2018 at 2:36 AM, Li Wei <liwei213@huawei.com> wrote:
> This patchset adds driver support for UFS for Hi3660 SoC. It is verified on HiKey960 board.
>
> Li Wei (4):
>   scsi: ufs: add Hisilicon ufs driver code
>   dt-bindings: scsi: ufs: add document for hisi-ufs
>   arm64: dts: add ufs dts node
>   arm64: defconfig: enable configs for Hisilicon ufs
>
>  Documentation/devicetree/bindings/ufs/ufs-hisi.txt |  41 ++
>  .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  10 +-
>  arch/arm64/boot/dts/hisilicon/hi3660.dtsi          |  18 +
>  arch/arm64/configs/defconfig                       |   1 +
>  drivers/scsi/ufs/Kconfig                           |   9 +
>  drivers/scsi/ufs/Makefile                          |   1 +
>  drivers/scsi/ufs/ufs-hisi.c                        | 619 +++++++++++++++++++++
>  drivers/scsi/ufs/ufs-hisi.h                        | 115 ++++
>  8 files changed, 811 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-hisi.txt
>  create mode 100644 drivers/scsi/ufs/ufs-hisi.c
>  create mode 100644 drivers/scsi/ufs/ufs-hisi.h


Martin/Vinayak: Wanted to nudge either of you to see if you had any
further feedback or objections on this patchset? Its been a long slow
slog for this patch-set and getting it upstream will make the HiKey960
board much more useful for testing mainline kernels.

If you don't have objections, would you consider merging the scsi
driver and Acked dt-bindings via the scsi tree?   Including the dts
changes too if Wei Xu (now cc'ed) acks it, would be helpful as well
(but that can go separately later if necessary).

The defconfig change isn't as important, so I suspect can be re-pushed
through the ARM maintainers later.

thanks
-john
