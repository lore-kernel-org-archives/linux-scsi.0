From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 1/9] ufs: sysfs: device descriptor
Date: Fri, 29 Dec 2017 10:23:27 +0100
Message-ID: <20171229092327.GB19402@kroah.com>
References: <1514467754-24499-1-git-send-email-stanislav.nijnikov@wdc.com>
 <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49190 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754830AbdL2JX0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Dec 2017 04:23:26 -0500
Content-Disposition: inline
In-Reply-To: <1514467754-24499-2-git-send-email-stanislav.nijnikov@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, alex.lemberg@wdc.com

On Thu, Dec 28, 2017 at 03:29:06PM +0200, Stanislav Nijnikov wrote:
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-sysfs.c
> @@ -0,0 +1,170 @@
> +/*
> +* UFS Device Management sysfs
> +*
> +* Copyright (C) 2017 Western Digital Corporation
> +*
> +* This program is free software; you can redistribute it and/or
> +* modify it under the terms of the GNU General Public License version
> +* 2 as published by the Free Software Foundation.
> +*
> +* This program is distributed in the hope that it will be useful, but
> +* WITHOUT ANY WARRANTY; without even the implied warranty of
> +* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +* General Public License for more details.

Please use the SPDX format for all of this, like I asked last time :(

thanks,

greg k-h
