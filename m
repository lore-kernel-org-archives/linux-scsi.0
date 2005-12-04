From: Denny Page <denny@cococafe.com>
Subject: Re: Adaptec aic79xx performance
Date: Sat, 03 Dec 2005 18:44:28 -0800
Message-ID: <4392580C.3050409@cococafe.com>
References: <439165A1.8070900@cococafe.com> <43916CE6.1090206@cococafe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:32906 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S932201AbVLDEDC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Dec 2005 23:03:02 -0500
Received: from marvin.cococafe.com (gw.cococafe.com [64.142.30.237])
	by mail.cococafe.com (Postfix) with ESMTP id CA9C4590
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 18:44:28 -0800 (PST)
Received: from [192.168.0.10] (daffy.cococafe.com [192.168.0.10])
	by marvin.cococafe.com (Postfix) with ESMTP id B6E5F7FF
	for <linux-scsi@vger.kernel.org>; Sat,  3 Dec 2005 18:44:28 -0800 (PST)
In-Reply-To: <43916CE6.1090206@cococafe.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Further research shows that this defect is new to kernel version 2.6.14. 
  I've tested 2.6.13 and a couple of previous kernels, and they 
correctly negotiate U160.

With 2.6.13, I am now receiving the expected 60+ MB per second with 
uncompressed data.

The defect appears to still be present in 2.6.15-rc4.

Hints and suggestions welcomed.

Thanks,

Denny
