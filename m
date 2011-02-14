From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Remove unused variable
Date: Mon, 14 Feb 2011 15:12:09 -0800
Message-ID: <1297725129.29207.34.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=dHh9Ombj=ZgA4AnPUyD3qo9kcr8z7UbXce-Or@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53887 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1BNXSq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2011 18:18:46 -0500
In-Reply-To: <AANLkTi=dHh9Ombj=ZgA4AnPUyD3qo9kcr8z7UbXce-Or@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fubo Chen <fubo.chen@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2011-02-14 at 20:09 +0100, Fubo Chen wrote:
> Does this patch make sense ?
> 
> ---
>  drivers/target/target_core_transport.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 

Hi Fubo,

> diff --git a/drivers/target/target_core_transport.c
> b/drivers/target/target_core_transport.c
> index 236e22d..d0e1ce8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -5828,14 +5828,12 @@ void transport_send_task_abort(struct se_cmd *cmd)
>   */
>  int transport_generic_do_tmr(struct se_cmd *cmd)
>  {
> -	struct se_cmd *ref_cmd;
>  	struct se_device *dev = SE_DEV(cmd);
>  	struct se_tmr_req *tmr = cmd->se_tmr_req;
>  	int ret;
> 
>  	switch (tmr->function) {
>  	case ABORT_TASK:
> -		ref_cmd = tmr->ref_cmd;
>  		tmr->response = TMR_FUNCTION_REJECTED;
>  		break;
>  	case ABORT_TASK_SET:

The usage of ref_cmd here will be used in for-39 code, so this should be
kept in place for now..

Thanks,

--nab

