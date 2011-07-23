From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_fc: remove duplicated #include
Date: Sat, 23 Jul 2011 02:20:48 -0700
Message-ID: <1311412848.31450.245.camel@haakon2.linux-iscsi.org>
References: <1311409299-2096-1-git-send-email-weiyi.huang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60277 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1GWJaF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Jul 2011 05:30:05 -0400
In-Reply-To: <1311409299-2096-1-git-send-email-weiyi.huang@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, openfcoe-devel <devel@open-fcoe.org>, "Patil, Kiran" <kiran.patil@intel.com>

On Sat, 2011-07-23 at 16:21 +0800, Huang Weiyi wrote:
> Remove duplicated #include('s) in
>   drivers/target/tcm_fc/tfc_cmd.c
>   drivers/target/tcm_fc/tfc_conf.c
>   drivers/target/tcm_fc/tfc_io.c
>   drivers/target/tcm_fc/tfc_sess.c
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>

Hi Huang,

This looks like a reasonable include cleanup to me.  Committed as
d818f87706 into lio-core-2.6.git..

Thanks!

--nab

> ---
>  drivers/target/tcm_fc/tfc_cmd.c  |    1 -
>  drivers/target/tcm_fc/tfc_conf.c |    1 -
>  drivers/target/tcm_fc/tfc_io.c   |    1 -
>  drivers/target/tcm_fc/tfc_sess.c |    2 --
>  4 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index a9e9a31..2aa2d5a 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -45,7 +45,6 @@
>  #include <target/target_core_device.h>
>  #include <target/target_core_tpg.h>
>  #include <target/target_core_configfs.h>
> -#include <target/target_core_base.h>
>  #include <target/target_core_tmr.h>
>  #include <target/configfs_macros.h>
>  
> diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
> index d63e3dd..8781d1e 100644
> --- a/drivers/target/tcm_fc/tfc_conf.c
> +++ b/drivers/target/tcm_fc/tfc_conf.c
> @@ -48,7 +48,6 @@
>  #include <target/target_core_device.h>
>  #include <target/target_core_tpg.h>
>  #include <target/target_core_configfs.h>
> -#include <target/target_core_base.h>
>  #include <target/configfs_macros.h>
>  
>  #include "tcm_fc.h"
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index 11e6483..8e2a46d 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -54,7 +54,6 @@
>  #include <target/target_core_device.h>
>  #include <target/target_core_tpg.h>
>  #include <target/target_core_configfs.h>
> -#include <target/target_core_base.h>
>  #include <target/configfs_macros.h>
>  
>  #include "tcm_fc.h"
> diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
> index fbcbb3d..dbb5eae 100644
> --- a/drivers/target/tcm_fc/tfc_sess.c
> +++ b/drivers/target/tcm_fc/tfc_sess.c
> @@ -46,10 +46,8 @@
>  #include <target/target_core_device.h>
>  #include <target/target_core_tpg.h>
>  #include <target/target_core_configfs.h>
> -#include <target/target_core_base.h>
>  #include <target/configfs_macros.h>
>  
> -#include <scsi/libfc.h>
>  #include "tcm_fc.h"
>  
>  static void ft_sess_delete_all(struct ft_tport *);

