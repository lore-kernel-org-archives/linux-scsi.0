From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] drivers: target: target_core_ua_h: Add #define of
 include guard
Date: Fri, 22 Aug 2014 14:13:08 -0700
Message-ID: <1408741988.24496.16.camel@haakon3.risingtidesystems.com>
References: <1408712071-14474-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408712071-14474-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Rasmus,

On Fri, 2014-08-22 at 14:54 +0200, Rasmus Villemoes wrote:
> Clearly the file was meant to contain an include guard, but it was
> missing the #define part.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  drivers/target/target_core_ua.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
> index be912b3..a6b56b3 100644
> --- a/drivers/target/target_core_ua.h
> +++ b/drivers/target/target_core_ua.h
> @@ -1,4 +1,5 @@
>  #ifndef TARGET_CORE_UA_H
> +#define TARGET_CORE_UA_H
>  
>  /*
>   * From spc4r17, Table D.1: ASC and ASCQ Assignement

Applied to target-pending.git.

Thanks!

--nab
