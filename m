From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/8]arch:ia64:perfmon.h change a typo comamnd to
 command
Date: Wed, 2 Feb 2011 11:33:51 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1102021132330.2160@pobox.suse.cz>
References: <1296623130-5130-1-git-send-email-justinmattock@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <1296623130-5130-1-git-send-email-justinmattock@gmail.com>
Sender: linux-ia64-owner@vger.kernel.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, megaraidlinux@lsi.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linville@tuxdriver.com, linux-wireless@vger.kernel.org, chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Tue, 1 Feb 2011, Justin P. Mattock wrote:

> The below patch fixes a typo comamnd to command.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  arch/ia64/include/asm/perfmon.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/perfmon.h b/arch/ia64/include/asm/perfmon.h
> index 7f3333d..d551183 100644
> --- a/arch/ia64/include/asm/perfmon.h
> +++ b/arch/ia64/include/asm/perfmon.h
> @@ -7,7 +7,7 @@
>  #define _ASM_IA64_PERFMON_H
>  
>  /*
> - * perfmon comamnds supported on all CPU models
> + * perfmon commands supported on all CPU models

I have consended all the patches in this thread (modulo the staging ones) 
into one and applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
