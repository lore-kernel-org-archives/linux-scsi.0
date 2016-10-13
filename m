From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] ufs: changing maintainer
Date: Thu, 13 Oct 2016 11:14:25 -0700
Message-ID: <77ae91fbc0580578e0fa1ad092082405@codeaurora.org>
References: <f5407f0a989e0bd67e648d418d44f11043d1fde4.1476379251.git.jpinto@synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43945 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934743AbcJMSQw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 14:16:52 -0400
In-Reply-To: <f5407f0a989e0bd67e648d418d44f11043d1fde4.1476379251.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao Pinto <Joao.Pinto@synopsys.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Manjunath.MB@synopsys.com, Prabu.T@synopsys.com, CARLOS.PALMINHA@synopsys.com, linux-scsi-owner@vger.kernel.org

On 2016-10-13 10:23, Joao Pinto wrote:
> Signed-off-by: Joao Pinto <jpinto@synopsys.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5ac91d8a..d9855b5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -12084,7 +12084,8 @@ F:	Documentation/scsi/ufs.txt
>  F:	drivers/scsi/ufs/
> 
>  UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
> -M:	Joao Pinto <Joao.Pinto@synopsys.com>
> +M:	Manjunath M Bettegowda <manjumb@synopsys.com>
> +M:	Prabu Thangamuthu <prabut@synopsys.com>
>  L:	linux-scsi@vger.kernel.org
>  S:	Supported
>  F:	drivers/scsi/ufs/*dwc*

Looking at the commit text, it gives the impression that we are changing 
the maintainer for whole UFS driver.
Can you make it specific? May be the commit text header should be "ufs: 
changing maintainer for DWC"?

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
