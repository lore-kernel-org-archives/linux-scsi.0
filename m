From: Jaehoon Chung <jh80.chung@samsung.com>
Subject: Re: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
Date: Fri, 01 Dec 2017 08:29:54 +0900
Message-ID: <c45b0de8-cdf3-eb15-3d46-c2c72edc1388@samsung.com>
References: <CGME20171128053631epcas1p389908b55511552b79b4083109dddc515@epcas1p3.samsung.com>
        <002a01d3680a$d8817200$89845600$@samsung.com>
        <df3398e9-01ca-e0e5-4f0d-00ecf42f8f35@samsung.com>
        <002801d36822$bc70eb50$3552c1f0$@samsung.com>
        <43ef9c93-3b9c-8f6a-c94d-90fb8f529439@samsung.com>
        <018001d369b6$22cfe290$686fa7b0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:56448 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750923AbdK3X3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Nov 2017 18:29:54 -0500
In-reply-to: <018001d369b6$22cfe290$686fa7b0$@samsung.com>
Content-language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?6rmA6riw7JuF?= <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: cpgs@samsung.com, 'HeonGwang Chu' <hg.chu@samsung.com>, =?UTF-8?B?J+q5gOu2gOynhCc=?= <boojin.kim@samsung.com>, 'YOUNGEUN PARK' <youngeun.park@samsung.com>

Hi,

On 11/30/2017 05:35 PM, 김기웅 wrote:
> Dear Jaehoon
> 
> Actually, I used to use the way what you mentioned, but
> now a new way has been using with latest products.
> 
> Anyway, I would refer to your comment.

If you will send the next version, you need to run "checkpatch".

When i run checkpatch, there are too many errors and warnings.

total: 37 errors, 62 warnings, 1340 lines checked

I also want that exynos ufs driver will be merged.

Best Regards,
Jaehoon Chung

> 
> Thank you.
> 
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Jaehoon Chung
>> Sent: Tuesday, November 28, 2017 6:21 PM
>> To: 김기웅; linux-scsi@vger.kernel.org; 'Martin K. Petersen'
>> Cc: cpgs@samsung.com; 'HeonGwang Chu'; '김부진'; 'YOUNGEUN PARK'
>> Subject: Re: [PATCH 2/2] scsi: ufs: add Exynos-specific driver
>>
>> On 11/28/2017 05:27 PM, 김기웅 wrote:
>>> Hi.
>>> This is modified from Seungwon's initial patch.
>>> And this has been used for several commercial products.
>>> I think you feel weird because you can't see a bunch of unipro and mphy.
>>> But those stuff has been changed whenever new product comes.
>>> So I didn't keep those in this driver.
