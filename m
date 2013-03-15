From: Naresh Kumar Inna <naresh@chelsio.com>
Subject: Re: [PATCH -next] [SCSI] csiostor: fix error return code in csio_hw_init()
Date: Fri, 15 Mar 2013 17:02:07 +0530
Message-ID: <514306B7.9030305@chelsio.com>
References: <CAPgLHd8QYmq+yER87eonRwb=hpGmuzy1oWSMB+RfHxQMVZ2BXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:2376 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3COLci (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Mar 2013 07:32:38 -0400
In-Reply-To: <CAPgLHd8QYmq+yER87eonRwb=hpGmuzy1oWSMB+RfHxQMVZ2BXg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: "JBottomley@parallels.com" <JBottomley@parallels.com>, "davem@davemloft.net" <davem@davemloft.net>, "jj@chaosbits.net" <jj@chaosbits.net>, Arvind Bhushan <arvindb@chelsio.com>, "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 3/15/2013 2:55 PM, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/scsi/csiostor/csio_hw.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
> index a0b4c89..d10afeb 100644
> --- a/drivers/scsi/csiostor/csio_hw.c
> +++ b/drivers/scsi/csiostor/csio_hw.c
> @@ -4036,6 +4036,7 @@ csio_hw_init(struct csio_hw *hw)
>  		evt_entry = kzalloc(sizeof(struct csio_evt_msg), GFP_KERNEL);
>  		if (!evt_entry) {
>  			csio_err(hw, "Failed to initialize eventq");
> +			rv = -ENOMEM;
>  			goto err_evtq_cleanup;
>  		}
>  
> 

Acked-by: Naresh Kumar Inna <naresh@chelsio.com>

Thanks,
Naresh.
