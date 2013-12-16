From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/32] target: Allocate more room for port default groups
Date: Mon, 16 Dec 2013 12:43:07 -0800
Message-ID: <1387226587.20247.194.camel@haakon3.risingtidesystems.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com>
	 <1386979160-6928-4-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37798 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3LPUmN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 15:42:13 -0500
In-Reply-To: <1386979160-6928-4-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 15:58 -0800, Andy Grover wrote:
> See target_stat_setup_port_default_groups, we need a 4 element array.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_fabric_configfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index dae2ad6..fdadc4d 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -906,7 +906,7 @@ static struct config_group *target_fabric_make_lun(
>  	lun_cg->default_groups[1] = NULL;
>  
>  	port_stat_grp = &lun->port_stat_grps.stat_group;
> -	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 3,
> +	port_stat_grp->default_groups =  kzalloc(sizeof(struct config_group) * 4,
>  				GFP_KERNEL);
>  	if (!port_stat_grp->default_groups) {
>  		pr_err("Unable to allocate port_stat_grp->default_groups\n");

Applied to for-next.

--nab

