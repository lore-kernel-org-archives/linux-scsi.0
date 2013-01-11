From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 5/5] target: Remove never-used TMR_FABRIC_TMR enum value
Date: Thu, 10 Jan 2013 20:42:27 -0800
Message-ID: <1357879347.20882.17.camel@haakon2.linux-iscsi.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
	 <1357159681-24477-6-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1357159681-24477-6-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-01-02 at 12:48 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  include/target/target_core_base.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 7cae236..02ed017 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -210,7 +210,6 @@ enum tcm_tmreq_table {
>  	TMR_LUN_RESET		= 5,
>  	TMR_TARGET_WARM_RESET	= 6,
>  	TMR_TARGET_COLD_RESET	= 7,
> -	TMR_FABRIC_TMR		= 255,
>  };
>  
>  /* fabric independent task management response values */

Applied to for-next.

Thanks again Roland!

--nab
