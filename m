From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 12/13] scsi: ufs-exynos: add UFS host support for Exynos SoCs
Date: Tue, 13 Oct 2015 13:38:52 +0200
Message-ID: <6499659.hVBcEphJIR@wuerfel>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com> <2228323.jdbqnSKW75@wuerfel> <561CE8CB.9010102@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <561CE8CB.9010102-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tuesday 13 October 2015 16:49:39 Alim Akhtar wrote:
> >> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> >> new file mode 100644
> >> index 0000000..58aa714
> >> --- /dev/null
> >> +++ b/drivers/scsi/ufs/ufs-exynos.h
> >> @@ -0,0 +1,463 @@
> >> +/*
> >> + * UFS Host Controller driver for Exynos specific extensions
> >> + *
> >> + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published by
> >> + * the Free Software Foundation; either version 2 of the License, or
> >> + * (at your option) any later version.
> >> + */
> >> +
> >> +#ifndef _UFS_EXYNOS_H_
> >> +#define _UFS_EXYNOS_H_
> >
> > You have a lot of things in this header that are only used in one of the
> > .c files, so just move them there and make the header as small as possible.
> >
> hmm..these are mostly the registers defines, will removes the one which 
> are not being used as of now.
> Do you think I should sill move them to .c file?
> 

Yes. No need to remove the unused register definitions, just don't put
them into a separate header if they are only used in one place.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
