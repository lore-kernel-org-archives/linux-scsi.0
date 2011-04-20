From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Add Marvell UMI driver
Date: Wed, 20 Apr 2011 07:26:26 -0700
Message-ID: <20110420142626.GA22114@kroah.com>
References: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4daee9cb.04558f0a.76dc.4776@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Li Jianyun <jianyunff@gmail.com>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 20, 2011 at 10:02:19PM +0800, Li Jianyun wrote:
> 
> 	The Marvell Universal Message Interface (UMI) defines a messaging
> interface between host and Marvell products. It considers situations of
> limited system resource and optimized system performance.
> 	UMI driver translates host request to message and sends message to
> FW via UMI, FW receives message and processes it, then sends response to
> UMI driver.
> 	FW generates an interrupt when it needs to send information or
> responseto UMI driver.
> 
> Signed-off-by: Jianyun Li <jianyunff@gmail.com>

Why not sign off using your marvell.com email address?

> +++ b/drivers/scsi/mvumi.c
> @@ -0,0 +1,2245 @@
> +/*
> + * Marvell UMI driver
> + *
> + * Copyright 2011 Marvell. <jyli@marvell.com>
> + *
> + * This file is licensed under GPLv2.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation; version 2 of the
> + * License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
> + * USA

Unless you are willing to track the office location of the FSF for the
next 40 years, and send patches updating it here, just drop this
paragraph, it's pointless, as the person _did_ get a copy with the
kernel.

thanks,

greg k-h
