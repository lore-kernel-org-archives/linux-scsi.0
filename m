From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/9] ufs: sysfs: device descriptor
Date: Wed, 27 Dec 2017 16:20:01 +0100
Message-ID: <20171227152001.GB20967@kroah.com>
References: <1514387627-27817-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514387627-27817-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514387627-27817-2-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Dec 27, 2017 at 05:13:39PM +0200, Stanislav Nijnikov wrote:
> diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
> new file mode 100644
> index 0000000..63a8e68
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -0,0 +1,158 @@
> +#include <linux/err.h>
> +#include <linux/string.h>
> +
> +#include "ufs.h"
> +#include "ufs-sysfs.h"

No SPDX license information or copyright info for this file?  That's
brave :(

> diff --git a/drivers/scsi/ufs/ufs-sysfs.h b/drivers/scsi/ufs/ufs-sysfs.h
> new file mode 100644
> index 0000000..369ba21
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-sysfs.h
> @@ -0,0 +1,10 @@
> +#ifndef __UFS_SYSFS_H__
> +#define __UFS_SYSFS_H__

Same comment here.

thanks,

greg k-h
