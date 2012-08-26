From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: remove unused including
 <generated/utsrelease.h>
Date: Sun, 26 Aug 2012 13:10:34 -0700
Message-ID: <1346011834.16636.22.camel@haakon2.linux-iscsi.org>
References: <CAPgLHd8f+HHquyGiGo=UQ-QLOB=uE37fkDPCDSi7zjiK_89=Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAPgLHd8f+HHquyGiGo=UQ-QLOB=uE37fkDPCDSi7zjiK_89=Dg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-08-26 at 08:38 +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove including <generated/utsrelease.h> that don't need it.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/target/target_core_fabric_configfs.c | 1 -
>  drivers/target/target_core_stat.c            | 1 -
>  2 files changed, 2 deletions(-)
> 

Ditto on this one too.

Thanks Wei!

--nab
