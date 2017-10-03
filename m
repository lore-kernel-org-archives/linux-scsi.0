From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH 1/3] scsi: ufs: Change HCI marco to actual bit position
Date: Tue, 3 Oct 2017 13:58:19 +0530
Message-ID: <5131c130-cae7-232b-1694-5669348bb724@samsung.com>
References: <CGME20170930062956epcas1p1461ea07e21a275a9e5733b3b90b5896a@epcas1p1.samsung.com>
        <1506752526-27014-1-git-send-email-alim.akhtar@samsung.com>
        <1506962493.3368.35.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:40854 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751313AbdJCIgB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2017 04:36:01 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20171003083559epoutp047bdf39082de71e43224c40fb91707746~qAnyTFT5o2413724137epoutp04c
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2017 08:35:59 +0000 (GMT)
In-Reply-To: <1506962493.3368.35.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>

Hi Bart,

On 10/02/2017 10:11 PM, Bart Van Assche wrote:
> On Sat, 2017-09-30 at 11:52 +0530, Alim Akhtar wrote:
>> Currently UFS HCI uses UFS_BIT() macro to get various bit
>> position for the hardware registers status bits. Which makes
>> code longer instead of shorter. This macro does not improve
>> code readability as well.
>> Lets re-write these macro definition with the actual bit position.
> 
> Can the three patches in this series be combined into a single patch?
> 
Since UFS_BIT() used in qcom-ufs driver as well, so I thought of keeping 
them in separate patches. This way "git bisect" will work all the time.

>> -#define UFS_BIT(x)	(1L << (x))
>> [ ... ]
>> +#define UFS_BIT(x)     (1L << (x))
> 
> If you want to keep the three patches separate, please make sure that this
> patch does not modify the UFS_BIT() definition. Please also fix the spelling
> of the title of this patch (marco -> macro).
> 
Ok, will fix these
> Thanks,
> 
> Bart.
> 
