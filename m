From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 17/24] libsas: switch remaining files to SPDX tags
Date: Sun, 5 May 2019 22:20:08 +0100
Message-ID: <c049de31-eff4-28b2-f4dc-4db2205895d2@huawei.com>
References: <20190501161417.32592-1-hch@lst.de>
 <20190501161417.32592-18-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190501161417.32592-18-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Willem Riede <osst@riede.org>, Doug Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, osst-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/05/2019 17:14, Christoph Hellwig wrote:
> Use the the GPLv2 SPDX tag instead of verbose boilerplate text.
>

Should we update the Kconfig+Makefile similarly?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/libsas/sas_discover.c  | 18 +-----------------
>  drivers/scsi/libsas/sas_event.c     | 18 +-----------------
>  drivers/scsi/libsas/sas_expander.c  | 16 +---------------
>  drivers/scsi/libsas/sas_host_smp.c  |  5 +----
>  drivers/scsi/libsas/sas_init.c      | 19 +------------------
>  drivers/scsi/libsas/sas_internal.h  | 19 +------------------
>  drivers/scsi/libsas/sas_phy.c       | 18 +-----------------
>  drivers/scsi/libsas/sas_port.c      | 18 +-----------------
>  drivers/scsi/libsas/sas_scsi_host.c | 19 +------------------
>  include/scsi/libsas.h               | 19 +------------------
>  include/scsi/sas.h                  | 19 +------------------
>  include/scsi/sas_ata.h              | 17 +----------------
>  12 files changed, 12 insertions(+), 193 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c

...

>  #include <linux/export.h>
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 83f2fd70ce76..76ea83ddafa7 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0
>  /*
>   * Serial Attached SCSI (SAS) Expander discovery and configuration
>   *
> @@ -5,21 +6,6 @@
>   * Copyright (C) 2005 Luben Tuikov <luben_tuikov@adaptec.com>
>   *
>   * This file is licensed under GPLv2.

Was this just missed?

> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation; either version 2 of the
> - * License, or (at your option) any later version.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - *
>   */
>
