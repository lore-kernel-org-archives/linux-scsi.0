From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH v2 04/10] phy: qcom-ufs-qmp-xx: Discard remove callback
 for drivers.
Date: Sun, 30 Oct 2016 01:46:46 +0530
Message-ID: <CAFp+6iG4kydcCLyYXur51_b_n4dtkfnWg9wsQy3=YHDg49wqPA@mail.gmail.com>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-5-git-send-email-vivek.gautam@codeaurora.org> <35ce06b5-8d80-57b4-1c27-4be57be1ecbc@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <35ce06b5-8d80-57b4-1c27-4be57be1ecbc@ti.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,


On Thu, Oct 27, 2016 at 1:50 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
>
>
> On Tuesday 18 October 2016 07:58 PM, Vivek Gautam wrote:
>> remove() callback does a phy_exit() only and nothing else now.
>
> remove callback calls a phy_power_off() ;-)

Yea, correct. My bad.  :)
Will correct.

[snip]


Thanks
Vivek

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
