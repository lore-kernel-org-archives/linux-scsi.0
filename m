From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [SCSI] ufs: Add missing dependency on CONFIG_HAS_IOMEM
Date: Wed, 12 Jun 2013 12:35:52 +0530
Message-ID: <CALMYJDvdnV31DmZA0yamW=_myAGu+OFkNzEYi-ZHub1SC9siDQ@mail.gmail.com>
References: <1370808274.5614.10.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1370808274.5614.10.camel@deadeye.wl.decadent.org.uk>
Sender: stable-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Debian kernel maintainers <debian-kernel@lists.debian.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-s390@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 10, 2013 at 1:34 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> The ufs driver doesn't build on s390 with CONFIG_PCI disabled as it
> requires MMIO functions.
>
> Marking for 3.9-stable only as CONFIG_SCSI_UFSHCD was previously
> dependent on CONFIG_PCI.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org # 3.9
> ---
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -34,7 +34,7 @@
>
>  config SCSI_UFSHCD
>         tristate "Universal Flash Storage Controller Driver Core"
> -       depends on SCSI
> +       depends on SCSI && HAS_IOMEM
>         ---help---
>         This selects the support for UFS devices in Linux, say Y and make
>           sure that you know the name of your UFS host adapter (the card
>

Acked-by: Santosh Y <santoshsy@gmail.com>

-- 
~Santosh
