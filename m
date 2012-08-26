From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_fc: remove unused including
 <generated/utsrelease.h>
Date: Sun, 26 Aug 2012 13:09:54 -0700
Message-ID: <1346011794.16636.21.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd8UgUtKdzPz+LvzTV2WUhxC7z_Bd__NQMt4F6B8DyDK4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd8UgUtKdzPz+LvzTV2WUhxC7z_Bd__NQMt4F6B8DyDK4A@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Wei,

On Sun, 2012-08-26 at 08:37 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <generated/utsrelease.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/target/tcm_fc/tfc_cmd.c  | 1 -
>  drivers/target/tcm_fc/tfc_io.c   | 1 -
>  drivers/target/tcm_fc/tfc_sess.c | 1 -
>  3 files changed, 3 deletions(-)
> 

Applied to target-pending.git/for-next.

Thanks Wei!

--nab
