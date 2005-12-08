From: Denny Page <denny@cococafe.com>
Subject: Re: Adaptec aic79xx performance
Date: Thu, 08 Dec 2005 12:50:32 -0800
Message-ID: <43989C98.9090505@cococafe.com>
References: <439165A1.8070900@cococafe.com> <43916CE6.1090206@cococafe.com> <4392580C.3050409@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:40333 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S1751048AbVLHUud
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 15:50:33 -0500
Received: from marvin.cococafe.com (gw.cococafe.com [64.142.30.237])
	by mail.cococafe.com (Postfix) with ESMTP id 8C88ABB
	for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2005 12:50:33 -0800 (PST)
Received: from [192.168.3.6] (unknown [192.168.3.6])
	by marvin.cococafe.com (Postfix) with ESMTP id 696CEB56
	for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2005 12:50:33 -0800 (PST)
In-Reply-To: <4392580C.3050409@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Is there anyone that would offer any suggestions on progressing the 
diagnosis?

Thanks,

Denny


Denny Page wrote:

> Further research shows that this defect is new to kernel version 
> 2.6.14.  I've tested 2.6.13 and a couple of previous kernels, and they 
> correctly negotiate U160.
>
> With 2.6.13, I am now receiving the expected 60+ MB per second with 
> uncompressed data.
>
> The defect appears to still be present in 2.6.15-rc4.
>
> Hints and suggestions welcomed.
>
> Thanks,
>
> Denny
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
