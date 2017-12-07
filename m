From: Philippe Ombredanne <pombredanne-od1rfyK75/E@public.gmane.org>
Subject: Re: [PATCH v6 1/5] scsi: ufs: add Hisilicon ufs driver code
Date: Thu, 7 Dec 2017 11:34:16 +0100
Message-ID: <CAOFm3uEgT4gzusQpXb3SnriTdU0nAha2tcVKOoZJRjZw=dx7sg@mail.gmail.com>
References: <20171207102026.14977-1-liwei213@huawei.com> <20171207102026.14977-2-liwei213@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171207102026.14977-2-liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org, "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>linux-
List-Id: linux-scsi@vger.kernel.org

Dear Li,

On Thu, Dec 7, 2017 at 11:20 AM, Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
> add Hisilicon ufs driver code.
>
> Signed-off-by: Li Wei <liwei213-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Geng Jianfeng <gengjianfeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> Signed-off-by: Zang Leigang <zangleigang-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> Signed-off-by: Yu Jianfeng <steven.yujianfeng-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
[]

> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -0,0 +1,624 @@
> +/*
> + *
> + * HiSilicon Hixxxx UFS Driver
> + *
> + * Copyright (c) 2016-2017 Linaro Ltd.
> + * Copyright (c) 2016-2017 HiSilicon Technologies Co., Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */

Would you consider using the new SPDX license ids instead?
Check Thomas doc patches for instructions.
This would be great and while you are it may be this could be adopted
for all HiSilicon and Huawei past, present and future contributions?
Thank you for your kind consideration!

-- 
Cordially
Philippe Ombredanne
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
