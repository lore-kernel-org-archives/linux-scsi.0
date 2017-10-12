From: Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] target/iscsi: make config_item_type const
Date: Thu, 12 Oct 2017 17:02:11 +0200
Message-ID: <CAOH+1jHSqVv=sf=d_hHYda1QF5YH36jATZU=20pqk5GSbKUT=Q@mail.gmail.com>
References: <1507816101-16427-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507816101-16427-1-git-send-email-bhumirks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>, nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 12, 2017 at 3:48 PM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> This is a followup patch for:
> https://patchwork.kernel.org/patch/9999649/
>
> Make config_item_type structures const as they are only passed to the
> functions having the argument as const. Make the declaration const too.
>
> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---

Hello,

This patch is dependent on the patch in the link
https://patchwork.kernel.org/patch/9999649/. Therefore, this patch
won't be correct unless the patch in this links gets applied.

Thanks,
Bhumika

>  drivers/target/iscsi/iscsi_target_stat.c | 12 ++++++------
>  include/target/iscsi/iscsi_target_stat.h | 12 ++++++------
>  2 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
> index 411cb26..df0a398 100644
> --- a/drivers/target/iscsi/iscsi_target_stat.c
> +++ b/drivers/target/iscsi/iscsi_target_stat.c
> @@ -187,7 +187,7 @@ static ssize_t iscsi_stat_instance_version_show(struct config_item *item,
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_instance_cit = {
> +const struct config_item_type iscsi_stat_instance_cit = {
>         .ct_attrs               = iscsi_stat_instance_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> @@ -249,7 +249,7 @@ static ssize_t iscsi_stat_sess_err_format_errors_show(struct config_item *item,
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_sess_err_cit = {
> +const struct config_item_type iscsi_stat_sess_err_cit = {
>         .ct_attrs               = iscsi_stat_sess_err_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> @@ -390,7 +390,7 @@ static ssize_t iscsi_stat_tgt_attr_fail_intr_addr_show(struct config_item *item,
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_tgt_attr_cit = {
> +const struct config_item_type iscsi_stat_tgt_attr_cit = {
>         .ct_attrs               = iscsi_stat_tgt_attr_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> @@ -522,7 +522,7 @@ static ssize_t iscsi_stat_login_negotiate_fails_show(struct config_item *item,
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_login_cit = {
> +const struct config_item_type iscsi_stat_login_cit = {
>         .ct_attrs               = iscsi_stat_login_stats_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> @@ -579,7 +579,7 @@ static ssize_t iscsi_stat_logout_abnormal_logouts_show(struct config_item *item,
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_logout_cit = {
> +const struct config_item_type iscsi_stat_logout_cit = {
>         .ct_attrs               = iscsi_stat_logout_stats_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> @@ -801,7 +801,7 @@ static ssize_t iscsi_stat_sess_conn_timeout_errors_show(
>         NULL,
>  };
>
> -struct config_item_type iscsi_stat_sess_cit = {
> +const struct config_item_type iscsi_stat_sess_cit = {
>         .ct_attrs               = iscsi_stat_sess_stats_attrs,
>         .ct_owner               = THIS_MODULE,
>  };
> diff --git a/include/target/iscsi/iscsi_target_stat.h b/include/target/iscsi/iscsi_target_stat.h
> index c27dd47..36e9c9a 100644
> --- a/include/target/iscsi/iscsi_target_stat.h
> +++ b/include/target/iscsi/iscsi_target_stat.h
> @@ -8,16 +8,16 @@
>  /*
>   * For struct iscsi_tiqn->tiqn_wwn default groups
>   */
> -extern struct config_item_type iscsi_stat_instance_cit;
> -extern struct config_item_type iscsi_stat_sess_err_cit;
> -extern struct config_item_type iscsi_stat_tgt_attr_cit;
> -extern struct config_item_type iscsi_stat_login_cit;
> -extern struct config_item_type iscsi_stat_logout_cit;
> +extern const struct config_item_type iscsi_stat_instance_cit;
> +extern const struct config_item_type iscsi_stat_sess_err_cit;
> +extern const struct config_item_type iscsi_stat_tgt_attr_cit;
> +extern const struct config_item_type iscsi_stat_login_cit;
> +extern const struct config_item_type iscsi_stat_logout_cit;
>
>  /*
>   * For struct iscsi_session->se_sess default groups
>   */
> -extern struct config_item_type iscsi_stat_sess_cit;
> +extern const struct config_item_type iscsi_stat_sess_cit;
>
>  /* iSCSI session error types */
>  #define ISCSI_SESS_ERR_UNKNOWN         0
> --
> 1.9.1
>
