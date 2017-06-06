From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v2 5/5] tcmu: Add Type of reconfig into netlink
Date: Mon, 5 Jun 2017 21:10:33 -0500
Message-ID: <59360F19.2010806@redhat.com>
References: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1496169080-58746-6-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751213AbdFFCKe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 5 Jun 2017 22:10:34 -0400
In-Reply-To: <1496169080-58746-6-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 05/30/2017 01:31 PM, Bryant G. Ly wrote:
> This patch adds more info about the attribute being changed,
> so that usersapce can easily figure out what is happening.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_user.c     | 27 +++++++++++++++++++++------
>  include/uapi/linux/target_core_user.h |  1 +
>  2 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 7575bc9..2d461c4 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -190,6 +190,13 @@ static struct genl_family tcmu_genl_family __ro_after_init = {
>  	.netnsok = true,
>  };
>  
> +enum tcmu_reconfig_types {
> +	No_reconfig,
> +	Config_path,
> +	Config_size,
> +	Config_writecache

This this goes in target_core_user.h.

Let's just do all caps for the names to make the style in there.
