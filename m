From: Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 4/8] PCI: consolidate PCI config entry in drivers/pci
Date: Thu, 18 Oct 2018 22:19:51 -0700
Message-ID: <CAMo8BfKOqAKLPEXatPZQ4bCAAzQLx_vAHscmxDJPC9PGsoJqtA@mail.gmail.com>
References: <20181017080201.10866-1-hch@lst.de> <20181017080201.10866-5-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017080201.10866-5-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, mporter@kernel.crashing.org, alex.bou9@gmail.com, linux@dominikbrodowski.net, linux-kbuild <linux-kbuild@vger.kernel.org>, linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-scsi@vger.kernel.org

Hi Christoph,

On Wed, Oct 17, 2018 at 1:03 AM Christoph Hellwig <hch@lst.de> wrote:
> diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
> index 4bb5b76d9524..818849bb7736 100644
> --- a/arch/xtensa/configs/iss_defconfig
> +++ b/arch/xtensa/configs/iss_defconfig
> @@ -4,7 +4,7 @@ CONFIG_EXPERT=y
>  CONFIG_SYSCTL_SYSCALL=y
>  # CONFIG_IOSCHED_DEADLINE is not set
>  # CONFIG_IOSCHED_CFQ is not set
> -# CONFIG_PCI is not set
> +CONFIG_PCI=y

This change doesn't make sense as there's no PCI hardware in the Xtensa ISS.
Otherwise for the Xtensa part:
Acked-by: Max Filippov <jcmvbkbc@gmail.com>

-- 
Thanks.
-- Max
