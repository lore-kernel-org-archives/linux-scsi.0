From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH 1/1] [SCSI] mpt3sas: Remove unneeded version.h header inclusion
Date: Mon, 10 Dec 2012 09:07:02 +0530
Message-ID: <CAK9yfHzjOCTtRgPaePzDenasjOsfTJMvPekV4+re_+gUzB2dzA@mail.gmail.com>
References: <1354528817-28894-1-git-send-email-sachin.kamat@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35011 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab2LJDhD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Dec 2012 22:37:03 -0500
Received: by mail-vb0-f46.google.com with SMTP id b13so2050553vby.19
        for <linux-scsi@vger.kernel.org>; Sun, 09 Dec 2012 19:37:02 -0800 (PST)
In-Reply-To: <1354528817-28894-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com, support@lsi.com, Sreekanth.Reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, sachin.kamat@linaro.org

ping..

On 3 December 2012 15:30, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> linux/version.h is not necessary as detected by checkversion.pl script.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c         |    1 -
>  drivers/scsi/mpt3sas/mpt3sas_config.c       |    1 -
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    1 -
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    1 -
>  drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    1 -
>  5 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 04f8010..d5e8463 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -42,7 +42,6 @@
>   * USA.
>   */
>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
> index ce7e59b..1df9ed4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -41,7 +41,6 @@
>   * USA.
>   */
>
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> index 8af944d..5b0d4f8 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -42,7 +42,6 @@
>   * USA.
>   */
>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 05f8045..ac9dbc2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -41,7 +41,6 @@
>   * USA.
>   */
>
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
> index da6c5f2..6f8d621 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
> @@ -42,7 +42,6 @@
>   * USA.
>   */
>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
> --
> 1.7.4.1
>



-- 
With warm regards,
Sachin
