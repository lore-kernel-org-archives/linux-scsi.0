From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH] target: Update copyright ownership to 2012
Date: Sat, 10 Nov 2012 12:15:21 +0200
Message-ID: <20121110101521.GA17489@shutemov.name>
References: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1352502014-9782-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Nov 09, 2012 at 11:00:14PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Hello everyone,
> 
> This patch to update copyright year to current for principal target core
> ownership is now being pushed into target-pending/for-next.
> 
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_alua.c            |    5 +++--
>  drivers/target/target_core_configfs.c        |    5 +++--
>  drivers/target/target_core_device.c          |    7 +++----
>  drivers/target/target_core_fabric_configfs.c |    7 ++++---
>  drivers/target/target_core_fabric_lib.c      |    5 +++--
>  drivers/target/target_core_file.c            |    7 +++----
>  drivers/target/target_core_hba.c             |    7 +++----
>  drivers/target/target_core_iblock.c          |    7 +++----
>  drivers/target/target_core_pr.c              |    5 +++--
>  drivers/target/target_core_pscsi.c           |    7 +++----
>  drivers/target/target_core_rd.c              |    7 +++----
>  drivers/target/target_core_sbc.c             |    7 +++----
>  drivers/target/target_core_spc.c             |    7 +++----
>  drivers/target/target_core_stat.c            |    7 +++----
>  drivers/target/target_core_tmr.c             |    5 +++--
>  drivers/target/target_core_tpg.c             |    7 +++----
>  drivers/target/target_core_transport.c       |    7 +++----
>  drivers/target/target_core_ua.c              |    5 +++--
>  18 files changed, 55 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 4c8eea2..035c606 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -3,8 +3,9 @@
>   *
>   * This file contains SPC-3 compliant asymmetric logical unit assigntment (ALUA)
>   *
> - * Copyright (c) 2009-2010 Rising Tide Systems
> - * Copyright (c) 2009-2010 Linux-iSCSI.org
> + * (c) Copyright 2009-2012 RisingTide Systems LLC.
> + *
> + * Licensed to the Linux Foundation under the General Public License (GPL) version 2.
>   *
>   * Nicholas A. Bellinger <nab@kernel.org>
>   *

Why do you remove Linux-iSCSI.org copyright?

-- 
 Kirill A. Shutemov
