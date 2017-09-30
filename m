From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Make use of UFS_BIT macro wherever possible
Date: Sat, 30 Sep 2017 11:54:59 +0530
Message-ID: <20be192d-a448-6603-b833-7a2ea718bb39@samsung.com>
References: <CGME20170828122625epcas2p33e3e912339c1e29051ad8e28251ea91b@epcas2p3.samsung.com>
        <1503922783-14317-1-git-send-email-alim.akhtar@samsung.com>
        <1503935147.2841.25.camel@wdc.com>
        <e26087fe-5e1b-c103-668d-43818765d3c9@samsung.com>
        <CAGOxZ52N=NLCZndc+sS1ym4zsdutk3keBv31-KNwe1u1bEfreg@mail.gmail.com>
        <yq160c6h8xn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:31925 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdI3Gcp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Sep 2017 02:32:45 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20170930063243epoutp02bafa5316ecd123092e8fa83fbd9ebe60~pEAT5NhbO0638606386epoutp02R
        for <linux-scsi@vger.kernel.org>; Sat, 30 Sep 2017 06:32:43 +0000 (GMT)
In-Reply-To: <yq160c6h8xn.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Alim Akhtar <alim.akhtar@gmail.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

Hi Martin,

On 09/26/2017 01:01 AM, Martin K. Petersen wrote:
> 
> Alim,
> 
>> Should I drop this patch and send another one which removes UFS_BIT()
>> macro?
> 
> I fail to see the point of UFS_BIT(). So yes.
> 
> Please make sure to CC: Subhash on ufs changes.
> 
Thanks for looking into this patch.
I have just posted https://lkml.org/lkml/2017/9/30/41 (a series of 3 
patches)
Please take a look.

Regards,
Alim
